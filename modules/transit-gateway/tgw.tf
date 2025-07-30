locals {
  # 1. VPC Attachment별 Route 목록 생성
  vpc_attachments_with_routes = chunklist(flatten([
    for k, v in var.vpc_attachments : setproduct([{ key = k }], v.tgw_routes) if var.create_tgw && can(v.tgw_routes)
  ]), 2)

  # TGW Routing Table id 선별
  tgw_route_table_ids = {
    for k, v in var.vpc_attachments :
    k => v.create_route_table ?
      aws_ec2_transit_gateway_route_table.this[k].id : v.transit_gateway_route_table_id
  }

  # 2. TGW Default Route Table 태그 병합
  tgw_default_route_table_tags_merged = merge(
    var.tags,
    { Name = var.name },
    var.tgw_default_route_table_tags,
  )

  # 3. VPC Route Table 별 CIDR 라우팅 정보 구성
  vpc_route_table_destination_cidr = flatten([
    for k, v in var.vpc_attachments : [
      for rtb_id in try(v.vpc_route_table_ids, []) : {
        rtb_id = rtb_id
        cidr   = v.tgw_destination_cidr
        tgw_id = var.create_tgw ? aws_ec2_transit_gateway.this[0].id : v.tgw_id
      }
    ]
  ])
}

################################################################################
# Transit Gateway
################################################################################

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  description = var.description
  amazon_side_asn                    = var.amazon_side_asn
  default_route_table_association    = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation    = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments     = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  multicast_support                  = var.enable_multicast_support ? "enable" : "disable"
  vpn_ecmp_support                   = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                        = var.enable_dns_support ? "enable" : "disable"
  transit_gateway_cidr_blocks        = var.transit_gateway_cidr_blocks
  security_group_referencing_support = var.enable_sg_referencing_support ? "enable" : "disable"
  
  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_tags,
  )
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = var.create_tgw ? aws_ec2_transit_gateway.this[0].id : each.value.tgw_id        # 붙을 대상이되는 TGW
  vpc_id             = each.value.vpc_id                                                              # 서브넷이 위치하는 VPC
  subnet_ids         = each.value.subnet_ids                                                          # TGW에 붙을 서브넷

  dns_support                                     = try(each.value.dns_support, true) ? "enable" : "disable"
  ipv6_support                                    = try(each.value.ipv6_support, false) ? "enable" : "disable"
  appliance_mode_support                          = try(each.value.appliance_mode_support, false) ? "enable" : "disable"
  security_group_referencing_support              = try(each.value.security_group_referencing_support, false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, true)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, true)

  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_vpc_attachment_tags,
    try(each.value.tags, {}),
  )
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if try(v.create_route_table, false)
  }

  transit_gateway_id = var.create_tgw ? aws_ec2_transit_gateway.this[0].id : each.value.tgw_id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_vpc_attachment_tags
  )
}

resource "aws_ec2_transit_gateway_route" "this" {
  count = var.create_tgw_routes ? length(local.vpc_attachments_with_routes) : 0

  destination_cidr_block = local.vpc_attachments_with_routes[count.index][1].destination_cidr_block
  blackhole              = try(local.vpc_attachments_with_routes[count.index][1].blackhole, null)

  transit_gateway_route_table_id = local.tgw_route_table_ids[local.vpc_attachments_with_routes[count.index][0].key]
  transit_gateway_attachment_id  = tobool(try(local.vpc_attachments_with_routes[count.index][1].blackhole, false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0].key].id : null
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v 
      if try(v.transit_gateway_default_route_table_association, true) != true
  }

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = local.tgw_route_table_ids[each.key]
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v
      if try(v.transit_gateway_default_route_table_propagation, true) != true
  }

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = local.tgw_route_table_ids[each.key]
}
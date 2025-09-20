module "chan-tgw" {
  source = "../../modules/transit-gateway"

################################################################################
# Transit Gateway
################################################################################

  name                                    = "chan-tgw"
  amazon_side_asn                         = 64512
  enable_dns_support                      = true
  enable_sg_referencing_support           = false
  enable_vpn_ecmp_support                 = true
  enable_default_route_table_association  = true
  enable_default_route_table_propagation  = true
  enable_multicast_support                = false
  enable_auto_accept_shared_attachments   = true

  transit_gateway_cidr_blocks             = []



################################################################################
# VPC Attachment
################################################################################

  vpc_attachments = {
    chan-vpc_attach = {
      vpc_id = "vpc-xxxxxxxxxxxxxxx"
      subnet_ids = ["subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxx"]

      dns_support                                     = true
      security_group_referencing_support              = true
      ipv6_support                                    = false
      appliance_mode_support                          = false

      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tgw_vpc_attachment_tags = {
        Name = "chan-vpc-attach"
      }
    }

    dev-vpc_attach = {
      vpc_id = "vpc-xxxxxxxxxxxxxxx"
      subnet_ids = ["subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxx"]

      dns_support                                     = true
      security_group_referencing_support              = true
      ipv6_support                                    = false
      appliance_mode_support                          = false

      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = true

      tgw_vpc_attachment_tags = {
        Name = "dev-vpc-attach"
      }
    }    

  }

################################################################################
# Route Table / Routes
################################################################################

  tgw_route_tables = {
    vpc-chan-rt = {
      tgw_routes = [
        { destination_cidr_block = "10.0.130.0/24",attachment = local.dev-vpc_attach_id },
        { destination_cidr_block = "10.10.10.0/24", attachment = local.dev-vpc_attach_id },
        { destination_cidr_block = "10.25.20.0/24",  attachment = local.chan-vpn_attach_id },
        { destination_cidr_block = "192.168.0.0/24",   attachment = local.chan-vpc_attach_id },
      ]
      attachments = {
        chan-vpc = local.chan-vpc_attach_id
        chan-vpn = local.chan-vpn_attach_id
      }
      propagations = {
        chan-vpc = local.chan-vpc_attach_id
      }
      tgw_route_table_tags = {
        Name = "vpc-chan-rt"
      }
    }
    
    vpc-dev-rt = {
      tgw_routes = [
        { destination_cidr_block = "10.10.10.0/24", attachment = local.dev-vpc_attach_id },
        { destination_cidr_block = "10.25.20.0/24",  attachment = local.chan-vpn_attach_id },
        { destination_cidr_block = "172.16.0.0/24", attachment = local.dev-vpc_attach_id },
        { destination_cidr_block = "192.168.0.0/24", attachment = local.chan-vpc_attach_id },
      ]
      attachments = {
        dev-vpc = local.dev-vpc_attach_id
      }
      propagations = {
      }
      tgw_route_table_tags = {
        Name = "vpc-dev-rt"
      }
    }

  }

################################################################################
# Tags
################################################################################

  tags = {
    Managed = "Managed by Terraform"
  }
}

module "dev-tgw" {
  source = "../../modules/transit-gateway"
  create_tgw = false

################################################################################
# VPC Attachment
################################################################################

  vpc_attachments = {
    chan-vpc_attach = {
      transit_gateway_id = local.dev-tgw_id

      vpc_id = "vpc-xxxxxxxxxxxxxxx"
      subnet_ids = ["subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxx"]
      dns_support                                     = true
      security_group_referencing_support              = true
      ipv6_support                                    = false
      appliance_mode_support                          = false

      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tgw_vpc_attachment_tags = {
        Name = "chan-vpc-attach"
      }
    }

    dev-vpc_attach = {
      transit_gateway_id = local.dev-tgw_id

      vpc_id = "vpc-xxxxxxxxxxxxxxx"
      subnet_ids = ["subnet-xxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxx"]
      dns_support                                     = true
      security_group_referencing_support              = true
      ipv6_support                                    = false
      appliance_mode_support                          = false

      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tgw_vpc_attachment_tags = {
        Name = "dev-vpc-attach"
      }
    }

  }

################################################################################
# Tags
################################################################################

  tags = {
    Managed = "Managed by Terraform"
  }
}
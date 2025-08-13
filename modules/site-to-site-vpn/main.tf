# https://github.com/terraform-aws-modules/terraform-aws-vpn-gateway/blob/master/main.tf

##############################
# Locals — mode & description
##############################
locals {
  preshared_key_provided     = length(var.tunnel1_preshared_key) > 0 && length(var.tunnel2_preshared_key) > 0
  preshared_key_not_provided = !local.preshared_key_provided

  internal_cidr_provided     = length(var.tunnel1_inside_cidr) > 0 && length(var.tunnel2_inside_cidr) > 0
  internal_cidr_not_provided = !local.internal_cidr_provided

  # Mode (kept for readability / potential conditional logic)
  tunnel_details_not_specified          = local.internal_cidr_not_provided && local.preshared_key_not_provided
  tunnel_details_specified              = local.internal_cidr_provided     && local.preshared_key_provided
  create_tunnel_with_internal_cidr_only = local.internal_cidr_provided     && local.preshared_key_not_provided
  create_tunnel_with_preshared_key_only = local.internal_cidr_not_provided && local.preshared_key_provided

  connection_identifier = var.connect_to_transit_gateway ? "TGW ${var.transit_gateway_id}" : "VPC ${var.vpc_id}"
  Description           = "VPN Connection: ${local.connection_identifier} / Customer Gateway ${var.customer_gateway_id}"
}

############################################
# Single VPN connection (replaces 4 variants)
############################################
resource "aws_vpn_connection" "this" {
  count = var.create_vpn_connection ? 1 : 0

  # One of the following must be set by caller
  vpn_gateway_id      = var.vpn_gateway_id
  transit_gateway_id  = var.transit_gateway_id

  customer_gateway_id = var.customer_gateway_id
  type                = "ipsec.1"

  static_routes_only  = var.vpn_connection_static_routes_only
  enable_acceleration = var.vpn_connection_enable_acceleration

  # Optional — set only if provided
  tunnel1_inside_cidr = local.internal_cidr_provided ? var.tunnel1_inside_cidr : null
  tunnel2_inside_cidr = local.internal_cidr_provided ? var.tunnel2_inside_cidr : null

  tunnel1_preshared_key = local.preshared_key_provided ? var.tunnel1_preshared_key : null
  tunnel2_preshared_key = local.preshared_key_provided ? var.tunnel2_preshared_key : null

  # Phase 1/2 & other tunnel options (shared across all modes)
  tunnel1_phase1_dh_group_numbers      = var.tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.tunnel2_phase1_dh_group_numbers

  tunnel1_phase1_encryption_algorithms = var.tunnel1_phase1_encryption_algorithms
  tunnel2_phase1_encryption_algorithms = var.tunnel2_phase1_encryption_algorithms

  tunnel1_phase1_integrity_algorithms  = var.tunnel1_phase1_integrity_algorithms
  tunnel2_phase1_integrity_algorithms  = var.tunnel2_phase1_integrity_algorithms

  tunnel1_phase1_lifetime_seconds      = var.tunnel1_phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds      = var.tunnel2_phase1_lifetime_seconds

  tunnel1_dpd_timeout_seconds          = var.tunnel1_dpd_timeout_seconds
  tunnel2_dpd_timeout_seconds          = var.tunnel2_dpd_timeout_seconds

  tunnel1_dpd_timeout_action           = var.tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_action           = var.tunnel2_dpd_timeout_action

  tunnel1_enable_tunnel_lifecycle_control = var.tunnel1_enable_tunnel_lifecycle_control
  tunnel2_enable_tunnel_lifecycle_control = var.tunnel2_enable_tunnel_lifecycle_control

  tunnel1_phase2_dh_group_numbers      = var.tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.tunnel2_phase2_dh_group_numbers

  tunnel1_phase2_encryption_algorithms = var.tunnel1_phase2_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.tunnel2_phase2_encryption_algorithms

  tunnel1_phase2_integrity_algorithms  = var.tunnel1_phase2_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.tunnel2_phase2_integrity_algorithms

  tunnel1_phase2_lifetime_seconds      = var.tunnel1_phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds      = var.tunnel2_phase2_lifetime_seconds

  tunnel1_rekey_margin_time_seconds    = var.tunnel1_rekey_margin_time_seconds
  tunnel2_rekey_margin_time_seconds    = var.tunnel2_rekey_margin_time_seconds

  tunnel1_rekey_fuzz_percentage        = var.tunnel1_rekey_fuzz_percentage
  tunnel2_rekey_fuzz_percentage        = var.tunnel2_rekey_fuzz_percentage

  tunnel1_replay_window_size           = var.tunnel1_replay_window_size
  tunnel2_replay_window_size           = var.tunnel2_replay_window_size

  tunnel1_startup_action               = var.tunnel1_startup_action
  tunnel2_startup_action               = var.tunnel2_startup_action

  tunnel1_ike_versions                 = var.tunnel1_ike_versions
  tunnel2_ike_versions                 = var.tunnel2_ike_versions

  ##########################################
  # Log options (kept exactly, via dynamics)
  ##########################################
  dynamic "tunnel1_log_options" {
    for_each = [var.tunnel1_log_options]
    content {
      dynamic "cloudwatch_log_options" {
        for_each = tunnel1_log_options.value
        content {
          log_enabled       = lookup(cloudwatch_log_options.value, "log_enabled", null)
          log_group_arn     = lookup(cloudwatch_log_options.value, "log_group_arn", null)
          log_output_format = lookup(cloudwatch_log_options.value, "log_output_format", null)
        }
      }
    }
  }

  dynamic "tunnel2_log_options" {
    for_each = [var.tunnel2_log_options]
    content {
      dynamic "cloudwatch_log_options" {
        for_each = tunnel2_log_options.value
        content {
          log_enabled       = lookup(cloudwatch_log_options.value, "log_enabled", null)
          log_group_arn     = lookup(cloudwatch_log_options.value, "log_group_arn", null)
          log_output_format = lookup(cloudwatch_log_options.value, "log_output_format", null)
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Description" = local.Description
    },
  )
}

#############################################################
# Attach VGW to VPC (when using VGW instead of Transit Gateway)
#############################################################
resource "aws_vpn_gateway_attachment" "default" {
  count = var.create_vpn_connection && var.create_vpn_gateway_attachment && !var.connect_to_transit_gateway ? 1 : 0

  vpc_id         = var.vpc_id
  vpn_gateway_id = var.vpn_gateway_id
}

#############################################################
# Propagate VGW to private route tables (VGW-only scenario)
#############################################################
resource "aws_vpn_gateway_route_propagation" "private_subnets_vpn_routing" {
  count = var.create_vpn_connection && !var.connect_to_transit_gateway ? var.vpc_subnet_route_table_count : 0

  vpn_gateway_id = var.vpn_gateway_id
  route_table_id = element(var.vpc_subnet_route_table_ids, count.index)
}

#######################################################
# Static routes on the VPN connection (if routes_only)
#######################################################
resource "aws_vpn_connection_route" "default" {
  count = var.create_vpn_connection && var.vpn_connection_static_routes_only && !var.connect_to_transit_gateway ? length(var.vpn_connection_static_routes_destinations) : 0

  vpn_connection_id     = aws_vpn_connection.this[0].id
  destination_cidr_block = element(var.vpn_connection_static_routes_destinations, count.index)
}

#############################################
# Tags for TGW attachments (TGW-only scenario)
#############################################
resource "aws_ec2_tag" "tags" {
  # Keep behavior: tag only when connecting to a TGW
  for_each = { for key, value in merge({ "Description" = local.Description }, var.tags) : key => value if var.create_vpn_connection && var.connect_to_transit_gateway }

  resource_id = aws_vpn_connection.this[0].transit_gateway_attachment_id
  key         = each.key
  value       = each.value
}

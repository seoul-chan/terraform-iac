##############################
# Customer gateways
##############################
resource "aws_customer_gateway" "hq_cgw1" {
  bgp_asn    = 65000                 # 온프레미스 장비의 ASN
  ip_address = "211.201.169.126"        # 온프레미스(고객측) Gateway의 퍼블릭 IP
  type       = "ipsec.1"             # 대부분의 VPN 환경에서 사용
  tags = {
    Name = "hq_cgw1"
  }
}

resource "aws_customer_gateway" "hq_cgw2" {
  bgp_asn    = 65000                 # 온프레미스 장비의 ASN
  ip_address = "58.237.174.86"        # 온프레미스(고객측) Gateway의 퍼블릭 IP
  type       = "ipsec.1"             # 대부분의 VPN 환경에서 사용
  tags = {
    Name = "hq_cgw2"
  }
}

##############################
# VPN connections - TGW
##############################
module "vpn_gateway_1" {
  source = "../modules/site-to-site-vpn"

  transit_gateway_id  = local.tgw_id
  customer_gateway_id = aws_customer_gateway.hq_cgw1.id

  connect_to_transit_gateway         = true
  vpn_connection_static_routes_only = true

  tags = {
    Name = "HQ-1_vpn"
  }
}

module "vpn_gateway_2" {
  source = "../modules/site-to-site-vpn"

  # vpc_id              = local.vpc_01_id
  transit_gateway_id  = local.tgw_id
  customer_gateway_id = aws_customer_gateway.hq_cgw2.id

  # tunnel inside cidr & preshared keys (optional)
  tunnel1_inside_cidr   = "169.254.44.88/30"
  tunnel2_inside_cidr   = "169.254.44.100/30"
  tunnel1_preshared_key = "1234567890abcdefghijklmn"
  tunnel2_preshared_key = "abcdefghijklmn1234567890"
  
  # option example
  tunnel1_phase1_encryption_algorithms = ["AES256","AES256-GCM-16"]
  tunnel2_phase1_encryption_algorithms = ["AES256","AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms = ["SHA2-256","SHA2-512"]
  tunnel2_phase1_integrity_algorithms = ["SHA2-256","SHA2-512"]
  tunnel1_phase1_lifetime_seconds = 27000
  tunnel2_phase1_lifetime_seconds = 27000
  tunnel1_phase2_lifetime_seconds = 3000
  tunnel2_phase2_lifetime_seconds = 3000
  tunnel1_phase1_dh_group_numbers = [16,17,18]
  tunnel2_phase1_dh_group_numbers = [16,17,18]
  tunnel1_phase2_dh_group_numbers = [2,5,16,23,24]
  tunnel2_phase2_dh_group_numbers = [2,5,16,23,24]

  tunnel1_dpd_timeout_seconds = 40
  tunnel2_dpd_timeout_seconds = 40
  tunnel1_dpd_timeout_action = "restart"
  tunnel2_dpd_timeout_action = "restart"

  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  connect_to_transit_gateway         = true
  vpn_connection_static_routes_only = false

  tags = {
    Name = "HQ-2_vpn"
  }
}

##############################
# VPN connections - VGW
##############################
# module "vpn_gateway_1" {
#   source = "../modules/site-to-site-vpn"

#   customer_gateway_id = aws_customer_gateway.hq_cgw1.id
#   vpc_id = local.vpc_01_id
#   vpn_gateway_id  = "vgw-0ede7005f72a43e5e"
#   vpn_connection_static_routes_destinations = ["1.1.1.1/32","1.1.1.2/32"]

#   vpn_connection_static_routes_only = true

#   tags = {
#     Name = "HQ-1-vgw"
#   }
# }

##############################
# Customer gateways
##############################
resource "aws_customer_gateway" "chan-cgw" {
  bgp_asn    = 65000           # 온프레미스 장비의 ASN
  ip_address = "x.x.x.x"       # 온프레미스 Gateway의 퍼블릭 IP
  type       = "ipsec.1"
  tags = {
    Name    = "chan-cgw"
    Managed = "Managed by Terraform"
  }
}

##############################
# VPN connections - TGW
##############################
module "chan-vpn" {
  source = "../modules/vpn_connection"

  transit_gateway_id  = local.chan-tgw_id
  customer_gateway_id = aws_customer_gateway.chan.id

  connect_to_transit_gateway        = true
  vpn_connection_static_routes_only = true

  tunnel1_dpd_timeout_action           = "restart"
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "2", "20", "21", "22", "23", "24"]
  tunnel1_phase1_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "2", "20", "21", "22", "23", "24", "5"]
  tunnel1_phase2_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_preshared_key                = "xxxx"
  tunnel1_startup_action               = "add"

  tunnel2_dpd_timeout_action           = "restart"
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "2", "20", "21", "22", "23", "24"]
  tunnel2_phase1_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_dh_group_numbers      = ["14", "15", "16", "17", "18", "19", "2", "20", "21", "22", "23", "24", "5"]
  tunnel2_phase2_encryption_algorithms = ["AES128", "AES128-GCM-16", "AES256", "AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_preshared_key                = "xxxx"
  tunnel2_startup_action               = "add"

  tags = {
    Name = "chan-vpn"
    Managed = "Managed by Terraform"
  }
}

data "terraform_remote_state" "dev_transit-gateway" {
  backend = "local"

  config = {
    path = "../dev/transit-gateway/terraform.tfstate"
  }
}

data "terraform_remote_state" "chan_vpn_connection" {
  backend = "local"

  config = {
    path = "../vpn_connection/terraform.tfstate"
  }
}

locals {
  # Attachments
  chan-vpc_attach_id = module.chan-tgw.ec2_transit_gateway_vpc_attachment["chan-vpc_attach"].id   # tgw-attach-xxxxxxxxxx
  dev-vpc_attach_id = module.chan-tgw.ec2_transit_gateway_vpc_attachment["dev-vpc_attach"].id     # tgw-attach-xxxxxxxxxx

  # dev-tgw
  dev-tgw_id = data.terraform_remote_state.dev_transit-gateway.outputs.ec2_transit_gateway_id

  # Site-to-Site VPN
  chan-vpn_attach_id = data.terraform_remote_state.chan_vpn_connection.outputs.chan_vpn_connection_transit_gateway_attachment_id
}


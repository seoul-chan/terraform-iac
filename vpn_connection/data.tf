data "terraform_remote_state" "chan-tgw_id" {
  backend = "local"

  config = {
    path = "../transit-gateway/terraform.tfstate"
  }
}

locals {
  chan-tgw_id = data.terraform_remote_state.chan-tgw_id.outputs.ec2_transit_gateway_id
}
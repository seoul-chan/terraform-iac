data "terraform_remote_state" "tgw_id" {
  backend = "local"

  config = {
    path = "../transit-gateway/terraform.tfstate"
  }
}

locals {
  tgw_id = data.terraform_remote_state.tgw_id.outputs.ec2_transit_gateway_id
}
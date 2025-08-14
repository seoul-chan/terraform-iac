data "terraform_remote_state" "vpc_id" {  # VGW 사용 시
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "tgw_id" {
  backend = "local"

  config = {
    path = "../transit-gateway/terraform.tfstate"
  }
}

locals {
  vpc_01_id = data.terraform_remote_state.vpc_id.outputs.vpc_01_id
  tgw_id = data.terraform_remote_state.tgw_id.outputs.ec2_transit_gateway_id
}
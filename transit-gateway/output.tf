################################################################################
# Transit Gateway
################################################################################

output "ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.chan-tgw.ec2_transit_gateway_id
}

################################################################################
# VPC Attachment
################################################################################

output "chan-tgw_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.chan-tgw.ec2_transit_gateway_vpc_attachment
}

output "dev-tgw_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.dev-tgw.ec2_transit_gateway_vpc_attachment
}
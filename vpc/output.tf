##############################
# VPC
##############################
output "vpc_01_id" {
  value = module.vpc_01.vpc_id
}

output "vpc_02_id" {
  value = module.vpc_02.vpc_id
}

output "vpc_03_id" {
  value = module.vpc_03.vpc_id
}

##############################
# Subnet
##############################
output "public_subnet_ids_vpc_01" {
  description = "Public Subnet IDs"
  value       = module.vpc_01.public_subnet_ids
}

output "private_subnet_ids_vpc_01" {
  description = "Private Subnet IDs"
  value       = module.vpc_01.private_subnet_ids
}

output "public_subnet_ids_vpc_02" {
  description = "Public Subnet IDs"
  value       = module.vpc_02.public_subnet_ids
}

output "private_subnet_ids_vpc_02" {
  description = "Private Subnet IDs"
  value       = module.vpc_02.private_subnet_ids
}

output "public_subnet_ids_vpc_03" {
  description = "Public Subnet IDs"
  value       = module.vpc_03.public_subnet_ids
}

output "private_subnet_ids_vpc_03" {
  description = "Private Subnet IDs"
  value       = module.vpc_03.private_subnet_ids
}

##############################
# Routing Table
##############################
output "public_route_table_ids_vpc_01" {
  description = "Public Subnet IDs"
  value       = module.vpc_01.public_route_table_ids
}

output "private_route_table_ids_vpc_01" {
  description = "Public Subnet IDs"
  value       = module.vpc_01.private_route_table_ids
}

output "public_route_table_ids_vpc_02" {
  description = "Public Subnet IDs"
  value       = module.vpc_02.public_route_table_ids
}

output "private_route_table_ids_vpc_02" {
  description = "Public Subnet IDs"
  value       = module.vpc_02.private_route_table_ids
}

output "public_route_table_ids_vpc_03" {
  description = "Public Subnet IDs"
  value       = module.vpc_03.public_route_table_ids
}

output "private_route_table_ids_vpc_03" {
  description = "Public Subnet IDs"
  value       = module.vpc_03.private_route_table_ids
}
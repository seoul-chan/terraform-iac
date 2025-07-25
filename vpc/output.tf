output "vpc_id_01" {
  value = module.vpc-01.vpc_id
}

output "vpc_id_02" {
  value = module.vpc-02.vpc_id
}

output "public_subnet_ids_vpc_01" {
  description = "Public Subnet IDs"
  value       = module.vpc-01.public_subnet_ids
}

output "private_subnet_ids_vpc_01" {
  description = "Private Subnet IDs"
  value       = module.vpc-01.private_subnet_ids
}

output "public_subnet_ids_vpc_02" {
  description = "Public Subnet IDs"
  value       = module.vpc-02.public_subnet_ids
}

output "private_subnet_ids_vpc_02" {
  description = "Private Subnet IDs"
  value       = module.vpc-02.private_subnet_ids
}
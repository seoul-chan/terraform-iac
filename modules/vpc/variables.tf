variable "region" {
  description = "AWS Region"
  default     = "ap-northeast-2"
}

variable "vpc_name" {
  description = "Prefix for naming resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "public_routes" {
  description = "List of route definitions"
  type = list(object({
    cidr_block         = string
    nat_gateway_id     = optional(string)
    gateway_id         = optional(string)
    transit_gateway_id = optional(string)
    vpc_peering_connection_id = optional(string)
    egress_only_gateway_id    = optional(string)
  }))
}

variable "private_routes" {
  description = "List of route definitions"
  type = list(object({
    cidr_block         = string
    nat_gateway_id     = optional(string)
    gateway_id         = optional(string)
    transit_gateway_id = optional(string)
    vpc_peering_connection_id = optional(string)
    egress_only_gateway_id    = optional(string)
  }))
}
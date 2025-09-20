variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "subnet_id" {
  type        = string
  default = "subnet-054f2d768a4bb1368"
}

variable "vpc_id" {
  type        = string
  default = "vpc-00c7e4d80b525440b"
}

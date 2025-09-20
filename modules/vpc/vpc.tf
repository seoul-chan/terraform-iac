##################
### VPC
##################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.vpc_name}_vpc"
  }
}

##################
### Subnet
##################

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}_public_${count.index + 1}"
    NetworkType = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}_private_${count.index + 1}"
    NetworkType = "Private"
  }
}

##################
### Gateway
##################

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}_igw"
  }
}

resource "aws_eip" "nat" {
  tags = {
    Name = "nat_eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public[0].id  # NAT은 퍼블릭 서브넷에 위치해야 함
    tags = {
        Name = "${var.vpc_name}_nat-gateway"
  }
}

# ##################
# ### Route Table
# ##################

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.public_routes
    content {
      cidr_block                   = route.value.cidr_block
      nat_gateway_id               = lookup(route.value, "nat_gateway_id", null)
      gateway_id                   = lookup(route.value, "gateway_id", null)
      transit_gateway_id           = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id    = lookup(route.value, "vpc_peering_connection_id", null)
      egress_only_gateway_id       = lookup(route.value, "egress_only_gateway_id", null)
    }
  }

  tags = {
    Name = "${var.vpc_name}_public_rt"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.private_routes
    content {
      cidr_block                   = route.value.cidr_block
      nat_gateway_id               = lookup(route.value, "nat_gateway_id", null)
      gateway_id                   = lookup(route.value, "gateway_id", null)
      transit_gateway_id           = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id    = lookup(route.value, "vpc_peering_connection_id", null)
      egress_only_gateway_id       = lookup(route.value, "egress_only_gateway_id", null)
    }
  }

  tags = {
    Name = "${var.vpc_name}_private_rt"
  }
}

# # Associate Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# # Associate each private subnet with this route table
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

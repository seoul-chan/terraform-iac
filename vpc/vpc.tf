module "vpc_01" {
    source = "../modules/vpc"

    region = "ap-northeast-2"

    vpc_name = "test_chan-01"
    vpc_cidr = "10.10.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]
    
    public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnet_cidrs = ["10.10.10.0/24", "10.10.20.0/24"]

    public_routes = [ 
      #   { cidr_block = "0.0.0.0/0", gateway_id = module.vpc-01.internet_gateway_id },
      #   { cidr_block = "172.30.10.0/24", gateway_id = module.vpc-01.internet_gateway_id }
     ]

     private_routes = [ 
      #   { cidr_block = "0.0.0.0/0", nat_gateway_id = module.vpc-01.nat_gateway_id },
      #   { cidr_block = "172.30.10.0/24", nat_gateway_id = module.vpc-01.nat_gateway_id }
     ]
}

module "vpc_02" {
    source = "../modules/vpc"

    region = "ap-northeast-2"

    vpc_name = "test_chan-02"
    vpc_cidr = "10.11.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]
    
    public_subnet_cidrs = ["10.11.1.0/24", "10.11.2.0/24"]
    private_subnet_cidrs = ["10.11.10.0/24", "10.11.20.0/24"]

    public_routes = [ 
      #   { cidr_block = "0.0.0.0/0", gateway_id = module.vpc-02.internet_gateway_id },
      #   { cidr_block = "172.30.10.0/24", gateway_id = module.vpc-02.internet_gateway_id }
     ]

     private_routes = [ 
      #   { cidr_block = "0.0.0.0/0", nat_gateway_id = module.vpc-02.nat_gateway_id },
      #   { cidr_block = "172.30.10.0/24", nat_gateway_id = module.vpc-02.nat_gateway_id }
     ]
}

module "vpc_03" {
    source = "../modules/vpc"

    region = "ap-northeast-2"

    vpc_name = "test_chan-03"
    vpc_cidr = "10.12.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]
    
    public_subnet_cidrs = ["10.12.1.0/24", "10.12.2.0/24"]
    private_subnet_cidrs = ["10.12.10.0/24", "10.12.20.0/24"]

    public_routes = [ 
      #   { cidr_block = "0.0.0.0/0", gateway_id = module.vpc-02.internet_gateway_id },
      #   { cidr_block = "172.30.10.0/24", gateway_id = module.vpc-02.internet_gateway_id }
     ]

     private_routes = [ 
      #   { cidr_block = "0.0.0.0/0", nat_gateway_id = module.vpc-02.nat_gateway_id },
      #   { cidr_block = "172.30.10.0/24", nat_gateway_id = module.vpc-02.nat_gateway_id }
     ]
}
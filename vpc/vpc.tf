module "vpc_01" {
    source = "../modules/vpc"

    vpc_name = "test_chan-01"
    vpc_cidr = "10.1.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]
    public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
    private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24"]

    public_routes = [ 
        { cidr_block = "0.0.0.0/0", gateway_id = module.vpc-01.internet_gateway_id },
     ]

     private_routes = [ 
        { cidr_block = "0.0.0.0/0", nat_gateway_id = module.vpc-01.nat_gateway_id },
     ]
}

module "vpc_02" {
    source = "../modules/vpc"

    vpc_name = "test_chan-02"
    vpc_cidr = "10.2.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]
    public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
    private_subnet_cidrs = ["10.2.10.0/24", "10.2.20.0/24"]

    public_routes = [ 
        { cidr_block = "0.0.0.0/0", gateway_id = module.vpc-02.internet_gateway_id },
     ]

     private_routes = [ 
        { cidr_block = "0.0.0.0/0", nat_gateway_id = module.vpc-02.nat_gateway_id },
     ]
}

module "vpc_03" {
    source = "../modules/vpc"

    vpc_name = "test_chan-03"
    vpc_cidr = "10.3.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]
    public_subnet_cidrs = ["10.3.1.0/24", "10.3.2.0/24"]
    private_subnet_cidrs = ["10.3.10.0/24", "10.3.20.0/24"]

    public_routes = [ 
        { cidr_block = "0.0.0.0/0", gateway_id = module.vpc-03.internet_gateway_id },
     ]

     private_routes = [ 
        { cidr_block = "0.0.0.0/0", nat_gateway_id = module.vpc-03.nat_gateway_id },
     ]
}
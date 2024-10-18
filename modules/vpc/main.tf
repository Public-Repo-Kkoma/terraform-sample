module "demo_vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.4.0"

    name = var.vpc_name
    cidr = var.vpc_cidr

    azs = ["ap-northeast-2a", "ap-northeast-2c"]
    # "10.0.1.0/24", "10.0.2.0/24"
    public_subnets = [for i in range(0, 2): cidrsubnet(var.vpc_cidr, 8, i)]
    # "10.0.101.0/24", "10.0.102.0/24"
    private_subnets = [for i in range(0, 2): cidrsubnet(var.vpc_cidr, 8, i + 100)]

    enable_nat_gateway = true
    single_nat_gateway = false
    one_nat_gateway_per_az = true

    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
    }
}



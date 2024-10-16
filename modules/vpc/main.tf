module "demo_vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.4.0"
    
    name = "demo-vpc"
    cidr = "10.0.0.0/16"

    azs = ["ap-northeast-2a", "ap-northeast-2c"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true

    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
    }
}


data "aws_ami" "demo_eks_ami" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
      name = "name"
      values = [ "amazon-eks-node-${local.cluster_version}-v*" ]
    }
}

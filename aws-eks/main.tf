terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.70.0"
    }
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">= 2.33.0"
    }
  }
}

provider "aws" {
  
}
module "demo_vpc" {
  source = "./modules/vpc"
  vpc_name = "dev"
  vpc_cidr = "10.0.0.0/16"
}
module "demo_eks" {
  source = "./modules/eks"
  cluster_name = "dev-cluster"
  cluster_version = "1.30"
  vpc_id = module.demo_vpc.vpc_id
  private_subnets = module.demo_vpc.private_subnets
}
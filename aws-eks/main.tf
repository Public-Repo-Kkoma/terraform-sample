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

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"

    # aws 명령어를 통해서, token 받기
    command = "aws"
    args = [ "eks", "get-token", "--cluster-name", module.eks.cluster_name ]
  }
}

module "demo_vpc" {
    source = "terraform-aws-modules/vpc/aws"
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

locals {
  cluster_name = "demo-cluster"
  cluster_version = "1.28"
}

data "aws_ami" "demo_eks_ami" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
      name = "name"
      values = [ "amazon-eks-node-${local.cluster_version}-v*" ]
    }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  # Secret encryption을 하는 옵션을 etcd에 저장되는 쿠버네티스 시크릿에 대해 
  # encryption을 지정할 지 여부를 적용하지 않음
  cluster_encryption_config = {}

  cluster_addons = {
    coredns = {
        most_recent = true
    }
    kube-proxy = {
        most_recent = true
    }
    vpc-cni = {
        most_recent = true
    }
  }

  vpc_id = module.demo_vpc.vpc_id
  subnet_ids = module.demo_vpc.private_subnets

  # 인증을 configmap 을 통해서 인증을 거치도록 설정
  # manage_aws_auth_configmap = true

  # managed node 그룹 생성
  eks_managed_node_groups = {
    demo = {
        name = "demo-ng"
        user_name_prefix = true

        subnet_ids = module.demo_vpc.private_subnets

        min_size = 1
        max_size = 2
        desired_size = 1

        ami_id = data.aws_ami.demo_eks_ami.id

        # control plane 과 통신 
        enable_bootstrap_user_data = true

        capacity_type = "ON_DEMAND"
        instance_type = ["t3.medium"]

        # node group에 붙게될 iam role
        create_iam_role = true
        iam_role_name = "demo-ng-role"
        iam_role_use_name_prefix = true
    }
  }
}

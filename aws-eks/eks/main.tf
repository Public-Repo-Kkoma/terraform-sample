provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"

    # aws 명령어를 통해서, token 받기
    command = "aws"
    args    = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

data "aws_ami" "sample_eks_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Secret encryption을 하는 옵션을 etcd에 저장되는 쿠버네티스 시크릿에 대해
  # encryption을 지정할지 여부를 적용하지 않음
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

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # 인증을 configmap을 통해서 인증을 거치도록 설정
  manage_aws_auth_configmap = true

  # managed node group 생성
  eks_managed_node_groups = {
    blue = {}
    green = {
      name             = "sample-ng"
      user_name_prefix = true
      subnet_ids       = var.private_subnets

      min_size     = 1
      max_size     = 2
      desired_size = 1

      ami_id = data.aws_ami.sample_eks_ami.id

      # control plane과 통신
      enable_bootstrap_user_data = true

      instance_type = ["t3.medium"]
      capacity_type = "SPOT"

      # node group에 붙게될 iam role
      create_iam_role          = true
      iam_role_name            = "sample-ng-role"
      iam_role_use_name_prefix = true

      # EBS Role 추가
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

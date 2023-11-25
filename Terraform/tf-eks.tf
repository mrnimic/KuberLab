module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"


  cluster_name    = "kuberlab-eks-cluster"
  cluster_version = "1.24"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  cluster_additional_security_group_ids = [aws_security_group.kuberlab-sg-cluster.id]

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
      iam_role_name = aws_iam_role.eks_managed_node_group.name
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
      iam_role_name = aws_iam_role.eks_managed_node_group.name
    }
  }
}
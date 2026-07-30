terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

resource "aws_eks_cluster" "ray_cluster" {
  name     = "ray-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config { subnet_ids = var.private_subnet_ids }
}

resource "aws_eks_node_group" "ray_node_group" {
  cluster_name    = aws_eks_cluster.ray_cluster.name
  node_group_name = "ray-cpu-nodegroup"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["m5.xlarge"]
  scaling_config { desired_size = 2, max_size = 5, min_size = 1 }
}

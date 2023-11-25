resource "aws_key_pair" "kuberLab-kp" {
  key_name   = "kuberlab-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_security_group" "kuberlab-sg-ec2" {
    vpc_id = "${module.vpc.vpc_id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [var.ssh-source-ip]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["10.0.0.0/8"]
    }
}

resource "aws_security_group" "kuberlab-sg-cluster" {
    vpc_id = "${module.vpc.vpc_id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["10.0.0.0/8"]
    }
}

resource "aws_iam_role" "eks_managed_node_group" {
  name = "eks-managed-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com",
      },
    }],
  })
}

resource "aws_iam_policy_attachment" "ecr_access" {
  name       = "ecr-access-to-eks-nodes"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.eks_managed_node_group.name]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "controlPlane" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  root_block_device {
    volume_size = 50
  }
  subnet_id = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids = ["${aws_security_group.kuberlab-sg-ec2.id}"]
  key_name = "${aws_key_pair.kuberLab-kp.id}"
  tags = {
    Name = "EKS Control Plane"
  }
}

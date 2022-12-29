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
  subnet_id = "${aws_subnet.kuberlab-pub-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.kuberlab-sg-ec2.id}"]
  key_name = "${aws_key_pair.kuberLab-kp.id}"
  tags = {
    Name = "EKS Control Plane"
  }
}

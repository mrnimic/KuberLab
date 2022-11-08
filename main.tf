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
resource "aws_vpc" "nimic-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name 
}
resource "aws_key_pair" "KuberLab" {
  key_name   = "kuberlab-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_subnet" "nimic-subnet-1" {
    vpc_id = "${aws_vpc.nimic-vpc.id}"
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "nimic-subnet-2" {
    vpc_id = "${aws_vpc.nimic-vpc.id}"
    cidr_block = "10.10.20.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1b"
}

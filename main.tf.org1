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

resource "aws_key_pair" "KuberLab" {
  key_name   = "kuberlab-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAlVjPoTZEQU/2jhXi94qIF1XvGKie46HFIexZlrXdgdYnRuRMeQKiN1LJ0S/CBMhzX/9CH8PnSasQ35AFBdhnECrKHc5jA6p7Xw0ivBKCBw5faVIoN+sYHQxbxpB305FH7VLVp6LEx8JdlnO5aVXQf7sqK9ZppbcZyH7TtiKYw8SYDR3PWugJ5poFnEP8Aub0Zzgz6+9IVnSB+575geZAwiozEEka/4QXCLBp6n5OGDFE78QHOWE3w1kxfdPmntKOKOttdr1L2gPAliWKsJ2afamGqga8afbi2yMnop7ygtrER19wc1xlNTVPZ1I70Jf3ECYTCAbxlSdGrDuP274l1iirMXo22B/JjQTQRVvrE8m0j/DQQ83ZGW3pRvTA96MTpDx2wlHS0H28nMgVVcKSHNZMkV++Mdt53G3E40FwvoQskKqv5MNOiIZFH2RZ9XsDRLi8oVR5KIspOTPgM4aJgeWrmNhOjQV+yJf1/W8g4xfYkuymYVFB7ZqtJjIhblE= nim@Nima.local"
}
resource "aws_vpc" "nimic-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name   
}
resource "aws_internet_gateway" "nimic-igw" {
  vpc_id = aws_vpc.nimic-vpc.id

  tags = {
    Name = "main"
  }
}
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.nimic-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nimic-igw.id
  }
}
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    route_table_id = "${aws_route_table.example.id}"
}
resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = "${aws_vpc.nimic-vpc.id}"
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1a"
}
resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.nimic-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  key_name = "${aws_key_pair.KuberLab.id}"
  tags = {
    Name = "HelloWorld"
  }
}


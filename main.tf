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
resource "aws_vpc" "kuberlab-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name 
}
resource "aws_key_pair" "kuberLab-kp" {
  key_name   = "kuberlab-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_internet_gateway" "kuberlab-igw" {
  vpc_id = aws_vpc.kuberlab-vpc.id

  tags = {
    Name = "kuberlab"
  }
}

resource "aws_route_table" "kuberlab-rt-pub-1" {
  vpc_id = aws_vpc.kuberlab-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kuberlab-igw.id
  }
}
resource "aws_route_table" "kuberlab-rt-pub-2" {
  vpc_id = aws_vpc.kuberlab-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kuberlab-igw.id
  }
}
resource "aws_route_table" "kuberlab-rt-priv-1" {
  vpc_id = aws_vpc.kuberlab-vpc.id
}
resource "aws_route_table" "kuberlab-rt-priv-2" {
  vpc_id = aws_vpc.kuberlab-vpc.id
}

resource "aws_subnet" "kuberlab-pub-subnet-1" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "kuberlab-pub-subnet-2" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    cidr_block = "10.10.20.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1b"
}
resource "aws_subnet" "kuberlab-priv-subnet-1" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    cidr_block = "10.10.30.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "kuberlab-priv-subnet-2" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    cidr_block = "10.10.40.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"
}

resource "aws_route_table_association" "kuberlab-rta-pub-subnet-1"{
    subnet_id = "${aws_subnet.kuberlab-pub-subnet-1.id}"
    route_table_id = "${aws_route_table.kuberlab-rt-pub-1.id}"
}
resource "aws_route_table_association" "kuberlab-rta-pub-subnet-2"{
    subnet_id = "${aws_subnet.kuberlab-pub-subnet-2.id}"
    route_table_id = "${aws_route_table.kuberlab-rt-pub-2.id}"
}
resource "aws_route_table_association" "kuberlab-rta-priv-subnet-1"{
    subnet_id = "${aws_subnet.kuberlab-priv-subnet-1.id}"
    route_table_id = "${aws_route_table.kuberlab-rt-priv-1.id}"
}
resource "aws_route_table_association" "kuberlab-rta-priv-subnet-2"{
    subnet_id = "${aws_subnet.kuberlab-priv-subnet-2.id}"
    route_table_id = "${aws_route_table.kuberlab-rt-priv-2.id}"
}

resource "aws_security_group" "kuberlab-sg-ec2" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    
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
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["10.0.0.0/8"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.kuberlab-sg-elb.id]
    }
}
resource "aws_security_group" "kuberlab-sg-elb" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "kuberlab-jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.kuberlab-pub-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.kuberlab-sg-ec2.id}"]
  key_name = "${aws_key_pair.kuberLab-kp.id}"
  tags = {
    Name = "Jenkins Instance"
  }
}
resource "aws_instance" "kuberlab-worker1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.kuberlab-pub-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.kuberlab-sg-ec2.id}"]
  key_name = "${aws_key_pair.kuberLab-kp.id}"
  tags = {
    Name = "Worker1"
  }
}
resource "aws_instance" "kuberlab-worker2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.kuberlab-pub-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.kuberlab-sg-ec2.id}"]
  key_name = "${aws_key_pair.kuberLab-kp.id}"
  tags = {
    Name = "Worker2"
  }
}
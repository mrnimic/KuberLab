resource "aws_vpc" "kuberlab-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name 
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

resource "aws_subnet" "kuberlab-pub-subnet-1" {
    vpc_id = "${aws_vpc.kuberlab-vpc.id}"
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-1a"
}

resource "aws_route_table_association" "kuberlab-rta-pub-subnet-1"{
    subnet_id = "${aws_subnet.kuberlab-pub-subnet-1.id}"
    route_table_id = "${aws_route_table.kuberlab-rt-pub-1.id}"
}
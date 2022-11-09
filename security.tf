resource "aws_key_pair" "kuberLab-kp" {
  key_name   = "kuberlab-key"
  public_key = file("~/.ssh/id_rsa.pub")
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

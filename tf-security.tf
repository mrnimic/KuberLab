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

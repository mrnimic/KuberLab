resource "aws_lb_target_group" "kuberlab-tg" {
  name     = "Kuberlab-TargetGroup"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.kuberlab-vpc.id
  health_check {
      healthy_threshold = 5
  }
}
resource "aws_lb_listener" "kuberlab-alb-listener" {
  load_balancer_arn = aws_lb.kuberlab-alb.arn
  port              = "2676"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kuberlab-tg.arn
  }
}
resource "aws_lb" "kuberlab-alb" {
  name            = "kuberlab-alb"
  security_groups = [aws_security_group.kuberlab-sg-elb.id]
  subnets         = [aws_subnet.kuberlab-pub-subnet-1.id , aws_subnet.kuberlab-pub-subnet-2.id]
}
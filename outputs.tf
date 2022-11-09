output "jenkins-public-ip" {
  value = aws_instance.kuberlab-jenkins.public_ip
}
output "jenkins-private-ip" {
  value = aws_instance.kuberlab-jenkins.private_ip
}
output "worker1-public-ip" {
  value = aws_instance.kuberlab-worker1.public_ip
}
output "worker1-private-ip" {
  value = aws_instance.kuberlab-worker1.private_ip
}
output "worker2-public-ip" {
  value = aws_instance.kuberlab-worker2.public_ip
}
output "worker2-private-ip" {
  value = aws_instance.kuberlab-worker2.private_ip
}
output "alb-address" {
  value = aws_lb.kuberlab-alb.dns_name
}

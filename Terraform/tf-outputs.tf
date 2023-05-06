output "controlPlane-public-ip" {
  value = aws_instance.controlPlane.public_ip
}
output "controlPlane-private-ip" {
  value = aws_instance.controlPlane.private_ip
}
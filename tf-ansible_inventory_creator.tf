resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      master = aws_instance.controlPlane.*.public_ip
    }
  )
  filename = "./ansible/hosts.cfg"
}
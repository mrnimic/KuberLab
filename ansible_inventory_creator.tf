resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      master = aws_instance.kuberlab-jenkins.*.public_ip
      worker1 = aws_instance.kuberlab-worker1.*.public_ip
      worker2 = aws_instance.kuberlab-worker2.*.public_ip
    }
  )
  filename = "./ansible/hosts.cfg"
}
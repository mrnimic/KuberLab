resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      master = aws_instance.controlPlane.*.public_ip
      cluster_name = module.eks.cluster_name
    }
  )
  filename = "./ansible/hosts.cfg"
}
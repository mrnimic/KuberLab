resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/../templates/inventory.tpl",
    {
      master = aws_instance.controlPlane.*.public_ip
      cluster_name = module.eks.cluster_name
      backend_ecr = aws_ecr_repository.bsb-backend.repository_url
      frontend_ecr = aws_ecr_repository.bsb-react.repository_url
    }
  )
  filename = "../ansible/hosts.cfg"
}
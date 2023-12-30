resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/../templates/inventory.tpl",
    {
      master = aws_instance.controlPlane.*.public_ip
      cluster_name = module.eks.cluster_name
      vote_ecr = aws_ecr_repository.voting-app-vote.repository_url
      result_ecr = aws_ecr_repository.voting-app-result.repository_url
      worker_ecr = aws_ecr_repository.voting-app-worker.repository_url
      seed_ecr = aws_ecr_repository.voting-app-seed.repository_url
    }
  )
  filename = "../ansible/hosts.cfg"
}
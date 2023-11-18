resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/../templates/inventory.tpl",
    {
      master = aws_instance.controlPlane.*.public_ip
      cluster_name = module.eks.cluster_name
      backend_ecr = aws_ecr_repository.trb-ruby.repository_url
      hr_ecr = aws_ecr_repository.trb-hr.repository_url
      questionnaire_ecr = aws_ecr_repository.trb-questionnaire.repository_url
      triage_ecr = aws_ecr_repository.trb-triage.repository_url
      unifier_ecr = aws_ecr_repository.trb-unifier.repository_url
      webapp_ecr = aws_ecr_repository.trb-webapp.repository_url
      enterprise_ecr = aws_ecr_repository.trb-enterprise.repository_url
    }
  )
  filename = "../ansible/hosts.cfg"
}
resource "aws_ecr_repository" "bsb-react" {
  name                 = "bsb-react"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "bsb-backend" {
  name                 = "bsb-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


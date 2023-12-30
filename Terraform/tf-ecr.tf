resource "aws_ecr_repository" "voting-app-vote" {
  name                 = "voting-app-vote"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "voting-app-result" {
  name                 = "voting-app-result"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "voting-app-worker" {
  name                 = "voting-app-voting-app-worker"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "voting-app-seed" {
  name                 = "voting-app-voting-app-seed"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
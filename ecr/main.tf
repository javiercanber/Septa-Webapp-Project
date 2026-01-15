# Septa ECR Repository
resource "aws_ecr_repository" "septa_ecr_repo" {
  name                 = "septa-ecr-repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
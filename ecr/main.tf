# Septa ECR Repository
resource "aws_ecr_repository" "septa_ecr_repo" {
  name                 = var.septa-repository-name
  image_tag_mutability = "IMMUTABLE"
  force_delete = true
  
  image_scanning_configuration {
    scan_on_push = true
  }
}
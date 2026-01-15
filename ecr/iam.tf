resource "aws_iam_policy" "septa_ecr_policy" {
  name        = "septa-ecr-policy"
  description = "Policy for ECR to allow ECS tasks to pull images"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["ecr:CreateRepository"]
        Effect   = "Allow"
        Resource = aws_ecr_repository.septa_ecr_repo.arn
      }
    ]
  })
}
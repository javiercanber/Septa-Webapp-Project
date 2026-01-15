# AWS ECS Cluster for Septa Webapp
resource "aws_ecs_cluster" "septa_ecs_cluster" {
  name = "septa-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
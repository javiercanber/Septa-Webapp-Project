# AWS ECS Cluster for Septa Webapp
resource "aws_ecs_cluster" "septa_ecs_cluster" {
  name = "septa-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Security Group Ingress Rule to Allow HTTPS Access from ECS to ECR
resource "aws_vpc_security_group_ingress_rule" "allow_https_from_ecs" {

  security_group_id = var.security_group_allow_private_access
  referenced_security_group_id = var.security_group_allow_private_access
  
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_ecs_task_definition" "septa_task_definition" {
  family                   = "septa-task-webapp"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "septa-webapp"
      image     = "${var.repository_url}:septa-webapp1.0.0"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      
       logConfiguration = {
          logDriver = "awslogs"
          options = {
            "awslogs-group"         = "/ecs/septa-webapp-logs"
            "awslogs-region"        = var.region
            "awslogs-stream-prefix" = "ecs"
          }
        }
    }
  ])
}

# ECS Service for Septa Webapp
resource "aws_ecs_service" "septa_ecs_service" {
  name            = "septa-ecs-service"
  cluster         = aws_ecs_cluster.septa_ecs_cluster.id
  task_definition = aws_ecs_task_definition.septa_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = var.private_subnet_cidr_blocks
    security_groups = [var.security_group_allow_private_access]
    assign_public_ip = false
  }
}
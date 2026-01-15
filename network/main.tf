# Detect available AWS zones
data "aws_availability_zones" "available" {
  state = "available"
}
# VPC Resource for Septa Project
resource "aws_vpc" "septa_vpc" {
  cidr_block       = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Public Subnet for Septa Project
resource "aws_subnet" "public_subnet" {
  for_each = toset(var.public_subnet_cidr_block)
  vpc_id            = aws_vpc.septa_vpc.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.public_subnet_cidr_block, each.value)]
  map_public_ip_on_launch = true
}

# Private Subnets for Septa Webapp Containers
resource "aws_subnet" "private_subnet" {
  for_each = toset(var.private_subnet_cidr_block)
  vpc_id            = aws_vpc.septa_vpc.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.private_subnet_cidr_block, each.value)]
}

# Private Route Table for Private Subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.septa_vpc.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

#Internet Gateway for Septa VPC
resource "aws_internet_gateway" "septa_igw" {
  vpc_id = aws_vpc.septa_vpc.id
}

#Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.septa_vpc.id

  route {
    cidr_block = var.client_ip
    gateway_id = aws_internet_gateway.septa_igw.id
  }
}

# Ingress Rule to Allow Public HTTP Access
resource "aws_vpc_security_group_ingress_rule" "allow_public_http" {
  security_group_id = aws_security_group.allow_private_access.id
  
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Security Group for Application Load Balancer
resource "aws_security_group" "allow_private_access" {
  name        = "allow-private-access"
  description = "Allow Private Access to ECS Containers"
  vpc_id      = aws_vpc.septa_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_access_ecs" {
  security_group_id = aws_security_group.allow_private_access.id
  cidr_ipv4         = aws_vpc.septa_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


# Application Load Balancer
resource "aws_lb" "alb_septa" {
  name               = "septa-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_private_access.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

}

# Target Group for ECS Service
resource "aws_lb_target_group" "septa_tg" {
  name        = "septa-webapp-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.septa_vpc.id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

# Listener for Application Load Balancer
resource "aws_lb_listener" "septa_listener" {
  load_balancer_arn = aws_lb.alb_septa.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.septa_tg.arn
  }
}

# ECR API Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.septa_vpc.id
  service_name        = "com.amazonaws.eu-west-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
  security_group_ids  = [aws_security_group.allow_private_access.id]
}

# ECR DKR Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.septa_vpc.id
  service_name        = "com.amazonaws.eu-west-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
  security_group_ids  = [aws_security_group.allow_private_access.id]
}

 # S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.septa_vpc.id
  service_name      = "com.amazonaws.eu-west-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id]
}

# CloudWatch Logs Endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.septa_vpc.id
  service_name        = "com.amazonaws.eu-west-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [for s in aws_subnet.private_subnet : s.id]
  security_group_ids  = [aws_security_group.allow_private_access.id]
}
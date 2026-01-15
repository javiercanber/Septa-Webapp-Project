# Detect available AWS zones
data "aws_availability_zones" "available" {
  state = "available"
}
# VPC Resource for Septa Project
resource "aws_vpc" "septa_vpc" {
  cidr_block       = var.cidr_block
}

# Public Subnet for Septa Project
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.septa_vpc.id
  cidr_block        = var.public_subnet_cidr_block
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
  subnets            = [for subnet in aws_subnet.private_subnet : subnet.id]

  enable_deletion_protection = true

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
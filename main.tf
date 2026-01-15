# Providers configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
    Environment = var.environment
    Project = var.project
  }
}
}

module "septa_networking" {
  
  source = "./network"

  cidr_block = var.cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  availability_zone = var.availability_zone
  client_ip = var.client_ip
}

module "septa_ecr" {
  source = "./ecr"
}

module "septa_ecs" {
  source = "./ecs"

  repository_url = module.septa_ecr.repository_url
  private_subnet_cidr_block = module.septa_networking.private_subnet_cidr_blocks
  region = var.region

}


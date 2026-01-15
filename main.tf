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

  cidr_block = module.septa_networking.cidr_block
  public_subnet_cidr_block = module.septa_networking.public_subnet_cidr_block
  private_subnet_cidr_block = module.septa_networking.private_subnet_cidr_block
  availability_zone = module.septa_networking.availability_zone
  client_ip = module.septa_networking.client_ip
}

module "septa_ecr" {
  source = "./ecr"
}

module "septa_ecs" {
  source = "./ecs"

  private_subnet = module.septa_networking.private_subnet

}


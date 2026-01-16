variable "region" {
  type = string
  description = "Specify AWS Region"
}

variable "environment" {
  type = string
  description = "Environment Tag"
}

variable "project" {
  type = string
  description = "Project Tag"
}

variable "cidr_block" {
  type        = string
  description = "IP address range for the VPC"
}

variable "public_subnet_cidr_block" {
  type        = list(string)
  description = "IP address range for the public subnet"
}

variable "private_subnet_cidr_block" {
  type        = list(string)
  description = "IP address range for the subnet"
}

variable "availability_zone" {
  type        = list(string)
  description = "The availability zone for the subnet"
}

variable "septa-repository-name" {
  type = string
  description = "ECR Repository Name"
}

variable "container_tag_image" {
  type        = string
  description = "Tag of the container image to deploy"
}
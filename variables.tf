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
  type        = string
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

variable "client_ip" {
  type = string
  description = "Client Public IP"
}

variable "allow_private_access" {
    type = string
    description = "Security group ID allowing private access"
}

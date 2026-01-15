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

variable "client_ip" {
  type = string
  description = "Client Public IP"
}
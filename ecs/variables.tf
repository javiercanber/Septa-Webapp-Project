variable "private_subnet_cidr_block" {
  type        = list(string)
  description = "IP address range for the subnet"
}

variable "region" {
  type = string
  description = "AWS Region"
}
variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "IP address range for the subnet"
}

variable "region" {
  type = string
  description = "AWS Region"
}

variable "repository_url" {
  type = string
  description = "ECR Repository URL"
}

variable "security_group_allow_private_access" {
  type = string
  description = "Security Group ID allowing private access"
}

variable "septa_tg" { 
  type = string
  description = "ARN of the Septa Target Group"
}
variable "private_subnet" {
    type = list(string)
    description = "List of private subnet IDs"
}

variable "allow_private_access" {
    type = string
    description = "Security group ID allowing private access"
}
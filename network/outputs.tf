output "private_subnet" {
  value = aws_subnet.private_subnet[each.key]
}

output "security_group_allow_private_access" {
  value = aws_security_group.allow_private_access.id
}


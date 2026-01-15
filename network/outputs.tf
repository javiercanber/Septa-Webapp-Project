output "private_subnet_cidr_blocks" {
  value = [for s in aws_subnet.private_subnet : s.id]
}

output "security_group_allow_private_access" {
  value = aws_security_group.allow_private_access.id
}

output "septa_tg" {
  value = aws_lb_target_group.septa_tg.arn
}


# Outputs for Security Group Module

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.main.name
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.main.arn
}

output "vpc_id" {
  description = "VPC ID where the security group is created"
  value       = aws_security_group.main.vpc_id
}

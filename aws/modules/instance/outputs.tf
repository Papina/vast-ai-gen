# Outputs for Instance Module

output "instance_ids" {
  description = "List of IDs of the instances"
  value       = aws_instance.main[*].id
}

output "instance_public_ips" {
  description = "List of public IP addresses of the instances"
  value       = aws_instance.main[*].public_ip
}

output "instance_private_ips" {
  description = "List of private IP addresses of the instances"
  value       = aws_instance.main[*].private_ip
}

output "instance_public_dns" {
  description = "List of public DNS names of the instances"
  value       = aws_instance.main[*].public_dns
}

output "instance_private_dns" {
  description = "List of private DNS names of the instances"
  value       = aws_instance.main[*].private_dns
}

output "instance_state" {
  description = "List of instance states"
  value       = aws_instance.main[*].state
}

output "instance_arn" {
  description = "ARN of the instances"
  value       = aws_instance.main[*].arn
}

output "key_pair_name" {
  description = "Name of the key pair created"
  value       = aws_key_pair.main.key_name
}

output "key_pair_fingerprint" {
  description = "Fingerprint of the key pair"
  value       = aws_key_pair.main.fingerprint
}
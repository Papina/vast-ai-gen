# Outputs for AWS Infrastructure

# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = module.vpc.vpc_id
# }

# output "public_subnet_ids" {
#   description = "IDs of the public subnets"
#   value       = module.vpc.public_subnet_ids
# }

# output "private_subnet_ids" {
#   description = "IDs of the private subnets"
#   value       = module.vpc.private_subnet_ids
# }

# output "instance_ids" {
#   description = "IDs of the EC2 instances"
#   value       = module.instances.instance_ids
# }

# output "instance_public_ips" {
#   description = "Public IP addresses of the instances"
#   value       = module.instances.instance_public_ips
# }

# output "instance_private_ips" {
#   description = "Private IP addresses of the instances"
#   value       = module.instances.instance_private_ips
# }

# output "instance_public_dns" {
#   description = "Public DNS names of the instances"
#   value       = module.instances.instance_public_dns
# }

# output "ssh_security_group_id" {
#   description = "ID of the SSH security group"
#   value       = module.vpc.ssh_security_group_id
# }

# output "web_security_group_id" {
#   description = "ID of the web security group"
#   value       = module.vpc.web_security_group_id
# }

output "ami" {
  description = "Name of the ami"
  value       = module.instances.chosen_ami.name
}
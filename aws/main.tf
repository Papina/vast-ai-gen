# Main Terraform Configuration for AWS Infrastructure

# Get availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC
module "vpc" {
  source = "./modules/network"

  network_prefix = "10.0"
  env            = var.env
}

# # Create EC2 Instances
# module "instances" {
#   source = "./modules/instance"

#   project_name           = var.project_name
#   environment            = var.environment
#   purpose               = var.purpose
#   instance_count        = var.instance_count
#   ami_id               = var.ami_id
#   instance_type        = var.instance_type
#   subnet_ids           = module.vpc.public_subnet_ids
#   security_group_ids   = [module.vpc.web_security_group_id, module.vpc.ssh_security_group_id]
#   key_name            = var.key_name
#   public_key_path     = var.public_key_path
#   user_data           = var.user_data
#   root_volume_type    = var.root_volume_type
#   root_volume_size    = var.root_volume_size
#   encrypt_root_volume = var.encrypt_root_volume


# }
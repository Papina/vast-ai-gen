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

# Create the Security Groups
module "security_groups" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc.vpc_id
  name = "linux-ssh"
}

# Create EC2 Instances
module "instances" {
  source = "./modules/instance"


  # instance_count        = var.instance_count

  # instance_type        = var.instance_type
  subnet_ids           = module.vpc.vpc.public.subnet_ids
  security_group_ids   = [module.security_groups.security_group_id]
  key_name            = "Old Faithful"

  user_data           = file("user-data.sh")
  # root_volume_type    = var.root_volume_type
  # root_volume_size    = var.root_volume_size
  # encrypt_root_volume = var.encrypt_root_volume


}
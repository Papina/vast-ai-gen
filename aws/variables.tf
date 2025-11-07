# Main Variables for AWS Infrastructure

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "env" {
  description = "Name of the project"
  type        = string
}

# VPC Configuration
variable "network_prefix" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0"
}


# # EC2 Instance Configuration
# variable "instance_count" {
#   description = "Number of instances to create"
#   type        = number
#   default     = 2
# }

# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t3.micro"
# }

# variable "ami_id" {
#   description = "AMI ID to use for instances"
#   type        = string
# }

# variable "key_name" {
#   description = "Name of the SSH key pair"
#   type        = string
# }

# variable "public_key_path" {
#   description = "Path to the public SSH key"
#   type        = string
#   default     = "~/.ssh/id_rsa.pub"
# }

# variable "purpose" {
#   description = "Purpose of the instances"
#   type        = string
#   default     = "web-server"
# }

# # Volume Configuration
# variable "root_volume_size" {
#   description = "Root volume size in GB"
#   type        = number
#   default     = 20
# }

# variable "root_volume_type" {
#   description = "Root volume type"
#   type        = string
#   default     = "gp3"
# }

# variable "encrypt_root_volume" {
#   description = "Whether to encrypt the root volume"
#   type        = bool
#   default     = false
# }

# # User Data
# variable "user_data" {
#   description = "User data script for instances"
#   type        = string
#   default     = null
# }
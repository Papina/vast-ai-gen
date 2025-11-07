# Variables for Instance Module

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "purpose" {
  description = "Purpose of the instance"
  type        = string
  default     = "general"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs to place instances in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "iam_instance_profile" {
  description = "IAM instance profile to associate"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data to pass to the instance"
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "encrypt_root_volume" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key ID for volume encryption"
  type        = string
  default     = null
}

variable "additional_volumes" {
  description = "List of additional volumes to attach"
  type = list(object({
    device_name = string
    volume_type = string
    volume_size = number
    encrypted   = bool
    kms_key_id  = string
  }))
  default = []
}

variable "network_interface_id" {
  description = "Network interface ID to attach (optional)"
  type        = string
  default     = null
}
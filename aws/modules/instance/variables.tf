# Variables for Instance Module

variable "ami_lookup" {
  description = "AMI lookup criteria"
  type = object({
    owner     = string
    os_filter = string
  })
  default = {
    owner     = "136693071363" # Official Debian AWS account
    os_filter = "debian-13-amd64-*"
  }
}



# variable "instance_count" {
#   description = "Number of instances to create"
#   type        = number
#   default     = 1
# }


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
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

# variable "iam_instance_profile" {
#   description = "IAM instance profile to associate"
#   type        = string
#   default     = null
# }

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
  default     = 150
}


# variable "kms_key_id" {
#   description = "KMS key ID for volume encryption"
#   type        = string
#   default     = null
# }

# variable "additional_volumes" {
#   description = "List of additional volumes to attach"
#   type = list(object({
#     device_name = string
#     volume_type = string
#     volume_size = number
#     encrypted   = bool
#     kms_key_id  = string
#   }))
#   default = []
# }

# variable "network_interface_id" {
#   description = "Network interface ID to attach (optional)"
#   type        = string
#   default     = null
# }
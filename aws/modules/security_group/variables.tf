# Variables for Security Group Module

variable "name" {
  description = "Name prefix for the security group"
  type        = string
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}

variable "additional_ingress_rules" {
  description = "List of additional ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

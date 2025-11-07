# Variables for the networking module

# Required Variables
variable "compartment_ocid" {
  description = "OCID of the compartment to create networking resources in"
  type        = string
}

variable "project_name" {
  description = "Name prefix for networking resources"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain for subnet creation"
  type        = string
}

# Network Configuration
variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Security Configuration
variable "allowed_ports" {
  description = "Object controlling which ports are allowed"
  type = object({
    ssh            = bool
    http           = bool
    https          = bool
    docker_registry = bool
  })
  default = {
    ssh            = true
    http           = true
    https          = true
    docker_registry = true
  }
}

variable "custom_ingress_ports" {
  description = "List of custom ingress ports to allow"
  type = list(object({
    min_port   = number
    max_port   = number
    description = string
  }))
  default = []
}

variable "outbound_allowed" {
  description = "Whether to allow outbound internet access"
  type        = bool
  default     = true
}

# Subnet Configuration
variable "create_public_subnet" {
  description = "Whether to create a public subnet"
  type        = bool
  default     = true
}

variable "prohibit_public_ip_on_vnic" {
  description = "Whether to prohibit public IP assignment to VNIC"
  type        = bool
  default     = false
}

# Tags
variable "tags" {
  description = "Tags to apply to all networking resources"
  type        = map(string)
  default     = {}
}
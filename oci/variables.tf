# OCI Authentication Variables
variable "tenancy_ocid" {
  description = "OCID of your tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the user to authenticate with"
  type        = string
}

variable "api_key_fingerprint" {
  description = "Fingerprint of the API key"
  type        = string
}

variable "api_key_path" {
  description = "Path to the private API key"
  type        = string
}

variable "region" {
  description = "OCI region (e.g., ap-sydney-1, us-ashburn-1)"
  type        = string
  default     = "ap-sydney-1"
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

# Compute Configuration
# Note: availability_domain now comes from the compartment module

variable "instance_shape" {
  description = "Shape of the compute instance (e.g., VM.Standard2.1, VM.Optimized3.Flex)"
  type        = string
  default     = "VM.Standard2.1"
}

variable "instance_cpu" {
  description = "Number of CPUs for flexible shapes"
  type        = number
  default     = null
}

variable "instance_memory" {
  description = "Amount of memory in GB for flexible shapes"
  type        = number
  default     = null
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for instance access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "docker_build_instance_name" {
  description = "Name of the Docker build instance"
  type        = string
  default     = "docker-build-instance"
}

# Image Configuration
variable "ubuntu_image_id" {
  description = "OCID of the Ubuntu image to use"
  type        = string
}

# Tags
variable "project_name" {
  description = "Name for tagging resources"
  type        = string
  default     = "docker-build-environment"
}

variable "compartment_name" {
  description = "Name of the compartment to create and use for infrastructure"
  type        = string
  default     = "main-env"
}
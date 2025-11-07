# Variables for the Docker module

# Required Variables
variable "compartment_ocid" {
  description = "OCID of the compartment to create the instance in"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain for the instance"
  type        = string
}

variable "subnet_id" {
  description = "OCID of the subnet to attach the instance to"
  type        = string
}

variable "project_name" {
  description = "Name prefix for the instance"
  type        = string
}

# Instance Configuration
variable "create_instance" {
  description = "Whether to create the Docker instance"
  type        = bool
  default     = true
}

variable "instance_name" {
  description = "Name of the Docker instance"
  type        = string
  default     = "docker-build-instance"
}

variable "instance_shape" {
  description = "Shape of the compute instance"
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

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the instance"
  type        = bool
  default     = true
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for instance access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Image Configuration
variable "use_latest_image" {
  description = "Whether to use the latest available image"
  type        = bool
  default     = true
}

variable "image_id" {
  description = "OCID of the image to use (ignored if use_latest_image is true)"
  type        = string
  default     = null
}

variable "os_name" {
  description = "Operating system name for the image data source"
  type        = string
  default     = "Canonical Ubuntu"
}

variable "os_version" {
  description = "Operating system version for the image data source"
  type        = string
  default     = "22.04"
}

# Docker Configuration
variable "docker_version" {
  description = "Version of Docker to install"
  type        = string
  default     = "latest"
}

variable "docker_install_script_path" {
  description = "Path to the Docker installation script"
  type        = string
  default     = "user-data.sh"
}

variable "additional_packages" {
  description = "Additional packages to install"
  type        = list(string)
  default     = []
}

variable "workspace_path" {
  description = "Path for the workspace directory"
  type        = string
  default     = "/home/ubuntu/workspace"
}

# Tags
variable "instance_tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}
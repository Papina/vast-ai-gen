# Variables for the compartment creation module

variable "compartment_name" {
  description = "Name of the compartment to create"
  type        = string
  validation {
    condition     = length(var.compartment_name) >= 1 && length(var.compartment_name) <= 100
    error_message = "Compartment name must be between 1 and 100 characters."
  }
}

variable "description" {
  description = "Description of the compartment"
  type        = string
  default     = "Compartment created via Terraform"
}

variable "parent_ocid" {
  description = "OCID of the parent compartment (usually root)"
  type        = string
}

variable "enable_delete" {
  description = "Whether to allow deletion of the compartment"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the compartment"
  type        = map(string)
  default     = {}
}

variable "create_dynamic_group" {
  description = "Whether to create a dynamic group for this compartment"
  type        = bool
  default     = false
}

variable "policies" {
  description = "List of policies to create for this compartment"
  type = list(object({
    name        = string
    description = string
    statements  = list(string)
  }))
  default = []
}

variable "create_default_policies" {
  description = "Whether to create default policies for the compartment"
  type        = bool
  default     = false
}
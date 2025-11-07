terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 5.0.0"
    }
  }
}

provider "oci" {
  # Configuration options
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.api_key_fingerprint
  private_key_path = var.api_key_path
  region           = var.region
}
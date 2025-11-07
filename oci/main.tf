# Get the root compartment (tenancy) OCID
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

# Create the main compartment
module "main_compartment" {
  source = "./modules/compartment"

  compartment_name = var.compartment_name
  description      = "Main environment compartment"
  parent_ocid      = data.oci_identity_tenancy.tenancy.id
  enable_delete    = true
  tags = {
    environment = "production"
    managed_by  = "terraform"
  }
}

# Use the networking module
# module "networking" {
#   source = "./modules/networking"

#   # Required parameters
#   compartment_ocid   = module.main_compartment.compartment_ocid
#   project_name       = var.project_name
#   availability_domain = module.main_compartment.availability_domain
  
#   # Optional networking configuration
#   vcn_cidr           = var.vcn_cidr
#   subnet_cidr        = var.subnet_cidr
  
#   # Security configuration
#   allowed_ports = {
#     ssh            = true
#     http           = true
#     https          = true
#     docker_registry = true
#   }
  
#   custom_ingress_ports = []
#   outbound_allowed     = true
  
#   # Subnet configuration
#   create_public_subnet       = true
#   prohibit_public_ip_on_vnic = false
# }

# # Use the docker module
# module "docker" {
#   source = "./modules/docker"

#   # Required parameters
#   compartment_ocid   = module.main_compartment.compartment_ocid
#   availability_domain = module.main_compartment.availability_domain
#   subnet_id          = module.networking.subnet_id
#   project_name       = var.project_name
  
#   # Instance configuration
#   create_instance      = true
#   instance_name        = var.docker_build_instance_name
#   instance_shape       = var.instance_shape
#   instance_cpu         = var.instance_cpu
#   instance_memory      = var.instance_memory
#   assign_public_ip     = true
#   ssh_public_key_path  = var.ssh_public_key_path
  
#   # Image configuration
#   use_latest_image     = true
#   image_id            = var.ubuntu_image_id
#   os_name             = "Canonical Ubuntu"
#   os_version          = "22.04"
  
#   # Docker configuration
#   docker_version           = "latest"
#   docker_install_script_path = "${path.module}/user-data.sh"
#   additional_packages      = []
#   workspace_path           = "/home/ubuntu/workspace"
  
#   # Tags
#   instance_tags = {
#     project     = var.project_name
#     purpose     = "docker-build"
#     cost_center = "development"
#   }
# }
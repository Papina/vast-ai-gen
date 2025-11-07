# Compute Instance for Docker builds
resource "oci_core_instance" "docker_build_instance" {
  count               = var.create_instance ? 1 : 0
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = var.instance_shape
  
  # Use flexible shapes if CPU and memory are specified
  dynamic "shape_config" {
    for_each = var.instance_cpu != null ? [1] : []
    content {
      ocpus         = var.instance_cpu
      memory_in_gbs = var.instance_memory
    }
  }

  # Image configuration
  source_details {
    source_id   = var.use_latest_image ? data.oci_core_images.ubuntu_images[0].images[0].id : var.image_id
    source_type = "image"
  }

  # Subnet configuration
  create_vnic_details {
    subnet_id       = var.subnet_id
    display_name    = "${var.instance_name}-vnic"
    assign_public_ip = var.assign_public_ip
  }

  # Metadata for Docker installation script
  metadata = {
    user_data = base64encode(templatefile(var.docker_install_script_path, {
      docker_version     = var.docker_version
      project_name       = var.project_name
      additional_packages = var.additional_packages
      workspace_path     = var.workspace_path
    }))
  }
}

# Data source to get the latest Ubuntu image
data "oci_core_images" "ubuntu_images" {
  count               = var.use_latest_image ? 1 : 0
  compartment_id      = var.compartment_ocid
  operating_system    = var.os_name
  operating_system_version = var.os_version
  sort_by             = "TIMECREATED"
  sort_order          = "DESC"
}
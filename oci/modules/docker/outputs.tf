# Outputs for the Docker module

output "instance_id" {
  description = "OCID of the Docker build instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].id : null
}

output "instance_name" {
  description = "Name of the Docker build instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].display_name : null
}

output "instance_shape" {
  description = "Shape of the Docker build instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].shape : null
}

output "instance_state" {
  description = "Current state of the Docker build instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].state : null
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].public_ip : null
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].private_ip : null
}

output "vnics" {
  description = "VNIC information for the instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].vnics : null
}

output "availability_domain" {
  description = "Availability domain of the instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].availability_domain : null
}

output "compartment_id" {
  description = "Compartment OCID of the instance"
  value       = var.create_instance ? oci_core_instance.docker_build_instance[0].compartment_id : null
}

output "ssh_connection" {
  description = "SSH connection command to access the instance"
  value       = var.create_instance ? "${oci_core_instance.docker_build_instance[0].public_ip}" : null
}

output "image_info" {
  description = "Information about the image used"
  value = {
    latest_image_used = var.use_latest_image
    image_ocid        = var.use_latest_image ? data.oci_core_images.ubuntu_images[0].images[0].id : var.image_id
    operating_system  = var.use_latest_image ? data.oci_core_images.ubuntu_images[0].images[0].operating_system : var.os_name
    os_version        = var.use_latest_image ? data.oci_core_images.ubuntu_images[0].images[0].operating_system_version : var.os_version
  }
}
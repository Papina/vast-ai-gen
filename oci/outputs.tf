# # Network Outputs
# output "vcn_id" {
#   description = "ID of the created VCN"
#   value       = oci_core_vcn.docker_build_vcn.id
# }

# output "vcn_cidr" {
#   description = "CIDR block of the VCN"
#   value       = oci_core_vcn.docker_build_vcn.cidr_block
# }

# output "subnet_id" {
#   description = "ID of the created subnet"
#   value       = oci_core_subnet.docker_build_subnet.id
# }

# output "subnet_cidr" {
#   description = "CIDR block of the subnet"
#   value       = oci_core_subnet.docker_build_subnet.cidr_block
# }

# # Compute Instance Outputs
# output "instance_id" {
#   description = "ID of the Docker build instance"
#   value       = oci_core_instance.docker_build_instance.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the instance"
#   value       = oci_core_instance.docker_build_instance.public_ip
# }

# output "instance_private_ip" {
#   description = "Private IP address of the instance"
#   value       = oci_core_instance.docker_build_instance.private_ip
# }

# output "instance_shape" {
#   description = "Shape of the instance"
#   value       = oci_core_instance.docker_build_instance.shape
# }

# # SSH Connection Info
# output "ssh_connection" {
#   description = "SSH connection command"
#   value       = "ssh -i ${var.ssh_public_key_path} ubuntu@${oci_core_instance.docker_build_instance.public_ip}"
# }

# # Security List
# output "security_list_id" {
#   description = "ID of the security list"
#   value       = oci_core_security_list.docker_build_security_list.id
# }
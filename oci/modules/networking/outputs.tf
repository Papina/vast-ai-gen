# Outputs for the networking module

output "vcn_id" {
  description = "ID of the created VCN"
  value       = oci_core_vcn.vcn.id
}

output "vcn_cidr" {
  description = "CIDR block of the VCN"
  value       = oci_core_vcn.vcn.cidr_block
}

output "vcn_dns_label" {
  description = "DNS label of the VCN"
  value       = oci_core_vcn.vcn.dns_label
}

output "internet_gateway_id" {
  description = "ID of the created Internet Gateway"
  value       = oci_core_internet_gateway.igw.id
}

output "route_table_id" {
  description = "ID of the created Route Table"
  value       = oci_core_route_table.route_table.id
}

output "security_list_id" {
  description = "ID of the created Security List"
  value       = oci_core_security_list.security_list.id
}

output "dhcp_options_id" {
  description = "ID of the created DHCP Options"
  value       = oci_core_dhcp_options.dhcp_options.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = var.create_public_subnet ? oci_core_subnet.subnet[0].id : null
}

output "subnet_cidr" {
  description = "CIDR block of the subnet"
  value       = var.create_public_subnet ? oci_core_subnet.subnet[0].cidr_block : null
}

output "all_subnet_ids" {
  description = "IDs of all created subnets"
  value       = oci_core_subnet.subnet[*].id
}

output "all_subnet_cidrs" {
  description = "CIDR blocks of all created subnets"
  value       = oci_core_subnet.subnet[*].cidr_block
}
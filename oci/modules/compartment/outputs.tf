# Outputs for the compartment module

output "compartment_id" {
  description = "OCID of the created compartment"
  value       = oci_identity_compartment.compartment.id
}

output "compartment_name" {
  description = "Name of the created compartment"
  value       = oci_identity_compartment.compartment.name
}

output "compartment_description" {
  description = "Description of the created compartment"
  value       = oci_identity_compartment.compartment.description
}

output "compartment_ocid" {
  description = "Full OCID of the created compartment"
  value       = oci_identity_compartment.compartment.id
}

output "availability_domain" {
  description = "First availability domain in the region"
  value       = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

output "dynamic_group_id" {
  description = "OCID of the created dynamic group (if created)"
  value       = var.create_dynamic_group ? oci_identity_dynamic_group.compartment_dynamic_group[0].id : null
}

output "dynamic_group_name" {
  description = "Name of the created dynamic group (if created)"
  value       = var.create_dynamic_group ? oci_identity_dynamic_group.compartment_dynamic_group[0].name : null
}

output "policies" {
  description = "List of created policy OCIDs"
  value       = {
    for i, policy in oci_identity_policy.compartment_policies : 
    i => policy.id
  }
}

output "default_policies" {
  description = "List of created default policy OCIDs"
  value       = var.create_default_policies ? {
    for i, policy in oci_identity_policy.compartment_default_policies : 
    i => policy.id
  } : null
}
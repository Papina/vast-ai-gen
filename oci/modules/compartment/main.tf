# Compartment creation module for Oracle Cloud Infrastructure

# Get availability domains for the region
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.parent_ocid
}

# Create a new compartment
resource "oci_identity_compartment" "compartment" {
  name          = var.compartment_name
  description   = var.description
  compartment_id = var.parent_ocid
  enable_delete = var.enable_delete

  freeform_tags = var.tags
}

# Optional: Create a dynamic group for the compartment
resource "oci_identity_dynamic_group" "compartment_dynamic_group" {
  count       = var.create_dynamic_group ? 1 : 0
  name        = "${var.compartment_name}-dynamic-group"
  description = "Dynamic group for ${var.compartment_name} compartment"
  compartment_id = var.parent_ocid
  matching_rule = "ANY { resource.type = 'computeinstance', resource.compartment.id = '${oci_identity_compartment.compartment.id}' }"
}

# Optional: Create policies for the compartment
resource "oci_identity_policy" "compartment_policies" {
  count      = length(var.policies)
  name       = "${var.compartment_name}-${var.policies[count.index].name}"
  description = var.policies[count.index].description
  compartment_id = oci_identity_compartment.compartment.id

  statements = var.policies[count.index].statements
}

# Optional: Create default policies
resource "oci_identity_policy" "compartment_default_policies" {
  count      = var.create_default_policies ? 3 : 0
  name       = "${var.compartment_name}-${count.index == 0 ? "compute-admin" : count.index == 1 ? "storage-admin" : "network-admin"}"
  description = "Default policy for ${var.compartment_name} compartment"
  compartment_id = oci_identity_compartment.compartment.id

  statements = count.index == 0 ? [
    "Allow group Administrators to manage compute-family in compartment ${var.compartment_name}",
    "Allow group Administrators to manage instance-family in compartment ${var.compartment_name}"
  ] : count.index == 1 ? [
    "Allow group Administrators to manage object-family in compartment ${var.compartment_name}",
    "Allow group Administrators to manage bucket-family in compartment ${var.compartment_name}"
  ] : [
    "Allow group Administrators to manage virtual-network-family in compartment ${var.compartment_name}",
    "Allow group Administrators to manage load-balancers in compartment ${var.compartment_name}"
  ]
}
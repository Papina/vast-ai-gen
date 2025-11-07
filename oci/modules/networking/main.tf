# Virtual Cloud Network (VCN)
resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-vcn"
  dns_label      = replace(var.project_name, "-", "")
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-igw"
}

# Route Table
resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-routetable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Security List
resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-security-list"

  # SSH access (port 22)
  dynamic "ingress_security_rules" {
    for_each = var.allowed_ports.ssh ? [1] : []
    content {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR"
      tcp_options {
        min = 22
        max = 22
      }
      description = "SSH access"
    }
  }

  # HTTP access (port 80)
  dynamic "ingress_security_rules" {
    for_each = var.allowed_ports.http ? [1] : []
    content {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR"
      tcp_options {
        min = 80
        max = 80
      }
      description = "HTTP access"
    }
  }

  # HTTPS access (port 443)
  dynamic "ingress_security_rules" {
    for_each = var.allowed_ports.https ? [1] : []
    content {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR"
      tcp_options {
        min = 443
        max = 443
      }
      description = "HTTPS access"
    }
  }

  # Docker registry access (ports 5000-5001)
  dynamic "ingress_security_rules" {
    for_each = var.allowed_ports.docker_registry ? [1] : []
    content {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR"
      tcp_options {
        min = 5000
        max = 5001
      }
      description = "Docker registry access"
    }
  }

  # Custom ports
  dynamic "ingress_security_rules" {
    for_each = var.custom_ingress_ports
    content {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR"
      tcp_options {
        min = ingress_security_rules.value.min_port
        max = ingress_security_rules.value.max_port
      }
      description = ingress_security_rules.value.description
    }
  }

  # Allow outbound traffic for package downloads and Docker pulls
  egress_security_rules {
    protocol    = "all"
    destination = var.outbound_allowed ? "0.0.0.0/0" : null
    destination_type = var.outbound_allowed ? "CIDR" : null
    description = "Allow outbound traffic"
  }
}

# DHCP Options for VCN
resource "oci_core_dhcp_options" "dhcp_options" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-dhcp-options"

  # Use Oracle's DNS servers
  options {
    server_type = "VcnLocalPlusInternet"
    type        = "DomainNameServer"
  }

  # Let VCN manage DNS resolution
  options {
    type        = "SearchDomain"
    search_domain_names = ["${oci_core_vcn.vcn.dns_label}.oraclevcn.com"]
  }
}

# Subnet
resource "oci_core_subnet" "subnet" {
  count               = var.create_public_subnet ? 1 : 0
  availability_domain = var.availability_domain
  cidr_block          = var.subnet_cidr
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.vcn.id
  display_name        = "${var.project_name}-subnet"
  security_list_ids   = [oci_core_security_list.security_list.id]
  route_table_id      = oci_core_route_table.route_table.id
  dhcp_options_id     = oci_core_dhcp_options.dhcp_options.id
  prohibit_public_ip_on_vnic = var.prohibit_public_ip_on_vnic
}
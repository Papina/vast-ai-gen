# Networking Module for Oracle Cloud Infrastructure

This module creates Oracle Cloud Infrastructure networking resources including VCN, subnets, security lists, and routing.

## Usage

### Basic Usage

```hcl
module "networking" {
  source = "./modules/networking"

  compartment_ocid   = "ocid1.compartment.oc1.phx.xxxxxxxxx"
  project_name       = "docker-build"
  availability_domain = "phx-ad-1"
}
```

### Advanced Usage with Custom Configuration

```hcl
module "networking" {
  source = "./modules/networking"

  # Required parameters
  compartment_ocid   = var.compartment_ocid
  project_name       = "production-app"
  availability_domain = "phx-ad-1"

  # Custom network configuration
  vcn_cidr           = "192.168.0.0/16"
  subnet_cidr        = "192.168.1.0/24"

  # Custom security rules
  allowed_ports = {
    ssh            = true
    http           = true
    https          = true
    docker_registry = false  # Disable Docker registry ports
  }

  # Add custom ports
  custom_ingress_ports = [
    {
      min_port   = 8080
      max_port   = 8080
      description = "Application port"
    },
    {
      min_port   = 3000
      max_port   = 3000
      description = "Development server"
    }
  ]

  outbound_allowed    = true

  # Subnet configuration
  create_public_subnet = false  # Private subnet
  prohibit_public_ip_on_vnic = true
}
```

## Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `compartment_ocid` | string | yes | - | OCID of the compartment to create resources in |
| `project_name` | string | yes | - | Name prefix for networking resources |
| `availability_domain` | string | yes | - | Availability domain for subnet creation |
| `vcn_cidr` | string | no | "10.0.0.0/16" | CIDR block for the VCN |
| `subnet_cidr` | string | no | "10.0.1.0/24" | CIDR block for the subnet |
| `allowed_ports` | object | no | {ssh=true, http=true, https=true, docker_registry=true} | Object controlling which ports are allowed |
| `custom_ingress_ports` | list(object) | no | [] | List of custom ingress ports to allow |
| `outbound_allowed` | bool | no | true | Whether to allow outbound internet access |
| `create_public_subnet` | bool | no | true | Whether to create a public subnet |
| `prohibit_public_ip_on_vnic` | bool | no | false | Whether to prohibit public IP assignment |

### Allowed Ports Object Structure

```hcl
allowed_ports = {
  ssh            = bool    # Port 22
  http           = bool    # Port 80
  https          = bool    # Port 443
  docker_registry = bool   # Ports 5000-5001
}
```

### Custom Ingress Ports Object Structure

```hcl
custom_ingress_ports = [
  {
    min_port   = number    # Minimum port number
    max_port   = number    # Maximum port number
    description = string   # Description of the port/service
  }
]
```

## Outputs

| Output | Description |
|--------|-------------|
| `vcn_id` | ID of the created VCN |
| `vcn_cidr` | CIDR block of the VCN |
| `vcn_dns_label` | DNS label of the VCN |
| `internet_gateway_id` | ID of the created Internet Gateway |
| `route_table_id` | ID of the created Route Table |
| `security_list_id` | ID of the created Security List |
| `dhcp_options_id` | ID of the created DHCP Options |
| `subnet_id` | ID of the created subnet (null if `create_public_subnet` is false) |
| `subnet_cidr` | CIDR block of the subnet (null if `create_public_subnet` is false) |
| `all_subnet_ids` | IDs of all created subnets |
| `all_subnet_cidrs` | CIDR blocks of all created subnets |

## Features

### Dynamic Security Rules
The module uses dynamic blocks to conditionally create security rules based on the `allowed_ports` configuration:
- SSH access (port 22)
- HTTP access (port 80)  
- HTTPS access (port 443)
- Docker registry access (ports 5000-5001)

### Custom Port Support
Add any additional ports using the `custom_ingress_ports` parameter.

### Flexible Subnet Creation
- Create public or private subnets
- Control public IP assignment with `prohibit_public_ip_on_vnic`

### Internet Gateway and Routing
- Automatically creates and configures Internet Gateway
- Sets up default route table for internet access

### DNS Configuration
- Configures DHCP options with Oracle's DNS servers
- Sets up VCN-local and internet DNS resolution

## Examples

### Development Environment

```hcl
module "dev_networking" {
  source = "./modules/networking"

  compartment_ocid   = module.dev_compartment.compartment_id
  project_name       = "development"
  availability_domain = var.availability_domain

  # Allow all common development ports
  allowed_ports = {
    ssh            = true
    http           = true
    https          = true
    docker_registry = true
  }

  custom_ingress_ports = [
    {
      min_port   = 3000
      max_port   = 3000
      description = "Node.js development server"
    },
    {
      min_port   = 8000
      max_port   = 8000
      description = "Python development server"
    }
  ]
}
```

### Production Environment (Private Subnet)

```hcl
module "prod_networking" {
  source = "./modules/networking"

  compartment_ocid   = module.prod_compartment.compartment_id
  project_name       = "production"
  availability_domain = var.availability_domain

  # More restrictive security
  allowed_ports = {
    ssh            = true   # Still allow SSH for administration
    http           = false  # No direct HTTP
    https          = true   # Only HTTPS
    docker_registry = false # No Docker registry exposed
  }

  # Private subnet only
  create_public_subnet       = false
  prohibit_public_ip_on_vnic = true
}
```

### Multi-Environment Setup

```hcl
# Base networking for development
module "base_networking" {
  source = "./modules/networking"

  compartment_ocid   = var.compartment_ocid
  project_name       = "base-network"
  availability_domain = var.availability_domain
  
  # Enable all development ports
  allowed_ports = {
    ssh            = true
    http           = true
    https          = true
    docker_registry = true
  }
}

# Specific networking for different services
module "web_networking" {
  source = "./modules/networking"

  compartment_ocid   = var.compartment_ocid
  project_name       = "web-service"
  availability_domain = var.availability_domain
  
  # Only web-related ports
  allowed_ports = {
    ssh            = false
    http           = true
    https          = true
    docker_registry = false
  }

  custom_ingress_ports = [
    {
      min_port   = 8080
      max_port   = 8080
      description = "Web application port"
    }
  ]
}
```

## Notes

- The module creates resources in a single availability domain
- For high availability across multiple ADs, instantiate the module multiple times
- Security rules are applied at the VCN level
- DNS resolution is handled by Oracle's VCN DNS
- Internet access requires the Internet Gateway and proper routing configuration
# Docker Module for Oracle Cloud Infrastructure

This module creates OCI compute instances optimized for Docker image building with automatic Docker installation and configuration.

## Usage

### Basic Usage

```hcl
module "docker_build" {
  source = "./modules/docker"

  compartment_ocid   = "ocid1.compartment.oc1.phx.xxxxxxxxx"
  availability_domain = "phx-ad-1"
  subnet_id          = "ocid1.subnet.oc1.phx.xxxxxxxxx"
  project_name       = "docker-build"
}
```

### Advanced Usage with Custom Configuration

```hcl
module "docker_build" {
  source = "./modules/docker"

  # Required parameters
  compartment_ocid   = var.compartment_ocid
  availability_domain = var.availability_domain
  subnet_id          = var.subnet_id
  project_name       = "production-build"

  # Instance configuration
  create_instance     = true
  instance_name       = "docker-build-prod"
  instance_shape      = "VM.Optimized3.Flex"
  instance_cpu        = 4
  instance_memory     = 16
  assign_public_ip    = true
  ssh_public_key_path = "~/.ssh/prod_key.pub"

  # Custom image configuration
  use_latest_image    = false
  image_id           = "ocid1.image.oc1.phx.xxxxxxxxxxxxx"
  os_name            = "Canonical Ubuntu"
  os_version         = "22.04"

  # Docker configuration
  docker_version                 = "24.0"
  additional_packages           = ["nginx", "redis"]
  workspace_path                = "/opt/build/workspace"

  # Tags
  instance_tags = {
    environment = "production"
    team        = "platform"
    managed_by  = "terraform"
  }
}
```

## Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `compartment_ocid` | string | yes | - | OCID of the compartment to create the instance in |
| `availability_domain` | string | yes | - | Availability domain for the instance |
| `subnet_id` | string | yes | - | OCID of the subnet to attach the instance to |
| `project_name` | string | yes | - | Name prefix for the instance |
| `create_instance` | bool | no | true | Whether to create the Docker instance |
| `instance_name` | string | no | "docker-build-instance" | Name of the Docker instance |
| `instance_shape` | string | no | "VM.Standard2.1" | Shape of the compute instance |
| `instance_cpu` | number | no | null | Number of CPUs for flexible shapes |
| `instance_memory` | number | no | null | Amount of memory in GB for flexible shapes |
| `assign_public_ip` | bool | no | true | Whether to assign a public IP to the instance |
| `ssh_public_key_path` | string | no | "~/.ssh/id_rsa.pub" | Path to the SSH public key |
| `use_latest_image` | bool | no | true | Whether to use the latest available image |
| `image_id` | string | no | null | OCID of the image to use |
| `os_name` | string | no | "Canonical Ubuntu" | Operating system name |
| `os_version` | string | no | "22.04" | Operating system version |
| `docker_version` | string | no | "latest" | Version of Docker to install |
| `docker_install_script_path` | string | no | "${path.module}/../user-data.sh" | Path to Docker installation script |
| `additional_packages` | list(string) | no | [] | Additional packages to install |
| `workspace_path` | string | no | "/home/ubuntu/workspace" | Path for the workspace directory |
| `instance_tags` | map(string) | no | {} | Tags to apply to the instance |

## Outputs

| Output | Description |
|--------|-------------|
| `instance_id` | OCID of the Docker build instance |
| `instance_name` | Name of the Docker build instance |
| `instance_shape` | Shape of the Docker build instance |
| `instance_state` | Current state of the Docker build instance |
| `public_ip` | Public IP address of the instance |
| `private_ip` | Private IP address of the instance |
| `vnics` | VNIC information for the instance |
| `availability_domain` | Availability domain of the instance |
| `compartment_id` | Compartment OCID of the instance |
| `ssh_connection` | Public IP for SSH connection |
| `image_info` | Information about the image used |

## Features

### Automatic Docker Installation
The module uses cloud-init to automatically install and configure:
- **Docker Engine** (latest stable or specified version)
- **Docker Compose** plugin
- **Additional development tools** (git, build-essential, etc.)
- **Custom packages** as specified
- **Workspace directory** for Docker builds

### Flexible Instance Configuration
- **Standard Shapes**: Use pre-defined shapes like VM.Standard2.1, VM.Standard2.2
- **Flexible Shapes**: Specify custom CPU and memory for optimal build performance
- **Public/Private Networking**: Control whether the instance has public IP access

### Image Management
- **Latest Image Detection**: Automatically finds the latest Ubuntu image
- **Custom Images**: Use specific image OCIDs for custom configurations
- **OS Flexibility**: Support for different operating systems

### SSH Key Management
- **SSH Key Configuration**: Automatically applies SSH keys to the instance
- **Key Path Flexibility**: Use any SSH key pair for access

## Examples

### Development Environment

```hcl
module "dev_docker" {
  source = "./modules/docker"

  compartment_ocid      = module.dev_compartment.compartment_id
  availability_domain   = var.availability_domain
  subnet_id            = module.networking.subnet_id
  project_name         = "development"

  # Smaller instance for cost optimization
  instance_shape       = "VM.Standard2.1"
  instance_cpu        = null
  instance_memory     = null

  # Enable public access
  assign_public_ip    = true
  ssh_public_key_path = "~/.ssh/dev_key.pub"

  # Latest Ubuntu with all features
  use_latest_image    = true
  additional_packages = ["vim", "tmux", "htop"]
  
  instance_tags = {
    environment = "development"
    team        = "engineering"
  }
}
```

### Production Build Environment

```hcl
module "prod_docker" {
  source = "./modules/docker"

  compartment_ocid      = module.prod_compartment.compartment_id
  availability_domain   = var.availability_domain
  subnet_id            = module.networking.subnet_id
  project_name         = "production"

  # High-performance instance
  instance_shape       = "VM.Optimized3.Flex"
  instance_cpu        = 8
  instance_memory     = 32

  # No public IP for security
  assign_public_ip    = false
  ssh_public_key_path = "~/.ssh/prod_key.pub"

  # Specific image for consistency
  use_latest_image    = false
  image_id           = data.oci_core_images.ubuntu_custom.image_id
  
  instance_tags = {
    environment = "production"
    compliance  = "sox"
    team        = "platform"
  }
}
```

### CI/CD Build Environment

```hcl
module "cicd_docker" {
  source = "./modules/docker"

  compartment_ocid      = module.cicd_compartment.compartment_id
  availability_domain   = var.availability_domain
  subnet_id            = module.networking.subnet_id
  project_name         = "cicd-build"

  # Medium instance for CI/CD workloads
  instance_shape       = "VM.Standard2.2"
  assign_public_ip     = false  # Access via bastion

  # Latest image with CI/CD tools
  use_latest_image     = true
  additional_packages  = ["docker-registry-client", "aws-cli", "git"]

  instance_tags = {
    purpose = "cicd"
    managed_by = "jenkins"
  }
}
```

## Docker Build Workflow

1. **Deploy Infrastructure**: Use Terraform to create the instance
2. **Connect via SSH**: Use the public IP and SSH key to access the instance
3. **Verify Docker**: Check Docker installation and functionality
4. **Clone Code**: Pull your project repository to the workspace
5. **Build Images**: Use standard Docker build commands
6. **Push to Registry**: Push built images to your Docker registry

## Notes

- The instance automatically installs Docker during boot via cloud-init
- SSH key access is required - ensure your public key is correctly configured
- For private instances, set up bastion host access or VPN connectivity
- Workspace directory is created with appropriate permissions
- Additional packages are installed after Docker setup for optimal performance
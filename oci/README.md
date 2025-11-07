# OCI Docker Build Infrastructure

This Terraform configuration sets up an Oracle Cloud Infrastructure (OCI) environment for Docker image building and includes a reusable compartment module.

## What This Creates

### Modular Infrastructure Components
- **Compartment Module** - Reusable Terraform module for creating OCI compartments with policies and dynamic groups
- **Networking Module** - Comprehensive module for VCN, subnets, security lists, and routing
- **Docker Build Instance** - Compute instance configured with Docker and development tools

### Modular Architecture Benefits
- **Reusable Components** - Both modules can be used across different projects
- **Separation of Concerns** - Each module handles a specific domain (networking vs compartments)
- **Flexible Configuration** - Modules accept custom parameters for different use cases
- **Consistent Structure** - Standardized approach across all infrastructure

### Compartment Module Features
- **Nested compartment creation** with proper hierarchy
- **Dynamic group creation** for compute instances
- **Policy management** with custom and default policies
- **Tagging** for cost allocation and resource management
- **Protection options** to prevent accidental deletion

### Networking Module Features
- **VCN Management** with configurable CIDR blocks
- **Dynamic Security Rules** for SSH, HTTP, HTTPS, Docker registry
- **Custom Port Support** for application-specific requirements
- **Public/Private Subnets** with flexible IP assignment
- **Internet Gateway and Routing** for connectivity
- **DNS Configuration** with Oracle's VCN DNS

### Docker Module Features
- **Automatic Docker Installation** via cloud-init user data
- **Flexible Instance Sizing** with standard and flexible shapes
- **Image Management** with latest image detection or custom images
- **SSH Key Integration** for secure access
- **Custom Package Support** for development tools
- **Workspace Configuration** for Docker build workflows
- **Tagging** for resource management and cost allocation

## Prerequisites

### 1. OCI Account Setup
- Oracle Cloud account with access to compute services
- API keys generated for authentication
- SSH key pair for instance access

### 2. Required Information
- Tenancy OCID
- User OCID  
- API key fingerprint
- API private key path
- Compartment OCID
- Availability domain name
- Ubuntu image OCID

### 3. Install Terraform
```bash
# macOS
brew install terraform

# Ubuntu/Debian
sudo apt install terraform

# Or download from https://terraform.io
```

## Setup Instructions

### 1. Configure Variables

Copy the example variables file and update with your values:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific OCI details:
```hcl
tenancy_ocid        = "ocid1.tenancy.oc1.phx.xxxxxxxxxxxxxxxxx"
user_ocid           = "ocid1.user.oc1.phx.xxxxxxxxxxxxxxxxx"
api_key_fingerprint = "xx:xx:xx:xx:xx:xx:xx:xx"
api_key_path        = "~/.oci/oci_api_key.pem"
region              = "ap-sydney-1"
compartment_ocid    = "ocid1.compartment.oc1.phx.xxxxxxxxxxxxxx"
availability_domain = "phx-ad-1"
ubuntu_image_id     = "ocid1.image.oc1.ap-sydney-1.xxxxxxxxxxxxx"
```

### 2. Find Required OCIDs

**Availability Domain:**
- Check your region: `ap-sydney-1`, `us-ashburn-1`, etc.
- Get AD name from OCI Console > Administration > Tenancy Details

**Ubuntu Image:**
- Go to OCI Console > Compute > Custom Images
- Or use the data source to automatically get latest Ubuntu 22.04

### 3. Initialize and Apply

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### 4. Connect to Instance

After successful deployment, use the SSH connection from outputs:
```bash
# SSH to the instance
ssh -i ~/.ssh/id_rsa ubuntu@<public-ip>

# Verify Docker installation
docker --version
docker-compose --version

# Test Docker
docker run hello-world
```

## Instance Configuration

The instance comes pre-installed with:
- **Docker Engine** (latest stable)
- **Docker Compose** v2.23.0
- **Development tools** (git, build-essential, vim, etc.)
- **Additional utilities** (jq, tree, tmux, htop)

## Security Features

- **SSH** access (port 22) - restricted to your public key
- **HTTP/HTTPS** access (ports 80/443)
- **Docker registry** access (ports 5000-5001)
- **Outbound internet** access for package downloads

## Docker Build Workflow

1. **Deploy infrastructure** with Terraform
2. **SSH to instance** and navigate to workspace
3. **Clone your code** or copy Dockerfiles
4. **Build images** using standard Docker commands
5. **Push to registry** when ready

## Resource Costs

Choose instance shapes based on your needs:

- **VM.Standard2.1**: 1 CPU, 15GB RAM - Small builds ($0.10/hour)
- **VM.Standard2.2**: 2 CPU, 30GB RAM - Moderate builds ($0.20/hour) 
- **VM.Standard2.4**: 4 CPU, 60GB RAM - Large builds ($0.40/hour)
- **VM.Optimized3.Flex**: Flexible CPU/Memory - Custom sizing

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Authentication errors**: Verify API key path and fingerprint
2. **Image not found**: Check Ubuntu image OCID for your region
3. **SSH connection failed**: Verify SSH public key path in variables
4. **Docker not working**: SSH to instance and check Docker service status

### Check Instance Logs

```bash
# View cloud-init logs
tail -f /var/log/cloud-init-output.log

# Check Docker service
sudo systemctl status docker

# Check Docker logs
journalctl -u docker
```

## Customization

### Modify Instance Shape

Edit `terraform.tfvars`:
```hcl
# Standard shape
instance_shape = "VM.Standard2.4"

# Or flexible shape
instance_shape = "VM.Optimized3.Flex"
instance_cpu = 4
instance_memory = 16
```

### Add More Ports

Modify the security list in `main.tf`:
```hcl
ingress_security_rules {
  protocol    = "6" # TCP
  source      = "0.0.0.0/0"
  source_type = "CIDR"
  tcp_options {
    min = 8080
    max = 8080
  }
  description = "Custom service"
}
```

## Using the Compartment Module

The project includes a reusable compartment module for creating OCI compartments with policies and dynamic groups:

### Example: Create a Docker Build Compartment

```bash
# First create compartments using the module
cp compartments.tf.example compartments.tf

# Or create compartments.tf manually:
```

```hcl
module "docker_build_compartment" {
  source = "./modules/compartment"

  compartment_name = "docker-build-env"
  description      = "Compartment for Docker build infrastructure"
  parent_ocid      = var.tenancy_ocid
  create_default_policies = true
  
  tags = {
    environment = "development"
    purpose     = "docker-builds"
  }
}
```

Then update your main.tf to use the compartment:
```hcl
# Use the created compartment for infrastructure
compartment_id = module.docker_build_compartment.compartment_id
```

## Using the Docker Module

The Docker module creates compute instances optimized for Docker image building with automatic Docker installation:

### Example: Create a Docker Build Instance

```hcl
module "docker_build" {
  source = "./modules/docker"

  compartment_ocid   = var.compartment_ocid
  availability_domain = var.availability_domain
  subnet_id          = module.networking.subnet_id
  project_name       = "docker-build"

  instance_shape       = "VM.Standard2.2"
  assign_public_ip     = true
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"
  
  instance_tags = {
    environment = "development"
    purpose     = "docker-builds"
  }
}
```

### Multi-Environment Setup

Create a complete environment hierarchy:

```hcl
# Root compartment for the project
module "project_compartment" {
  source = "./modules/compartment"
  
  compartment_name      = "my-project"
  description          = "Main project compartment"
  parent_ocid          = var.tenancy_ocid
  create_default_policies = true
}

# Development environment
module "dev_compartment" {
  source = "./modules/compartment"
  
  compartment_name = "development"
  description      = "Development environment"
  parent_ocid      = module.project_compartment.compartment_id
  create_dynamic_group = true
}

# Staging environment
module "staging_compartment" {
  source = "./modules/compartment"
  
  compartment_name      = "staging"
  description          = "Staging environment"
  parent_ocid          = module.project_compartment.compartment_id
  enable_delete        = false  # Protect staging
  create_default_policies = true
}

# Production environment
module "prod_compartment" {
  source = "./modules/compartment"
  
  compartment_name      = "production"
  description          = "Production environment"
  parent_ocid          = module.project_compartment.compartment_id
  enable_delete        = false  # Protect production
  create_default_policies = true
  
  policies = [
    {
      name        = "production-admin"
      description = "Production administration policy"
      statements  = [
        "Allow group ProductionAdmins to manage all-resources in compartment production"
      ]
    }
  ]
}
```

## Files Structure

### Main Configuration
- `terraform-provider.tf` - OCI provider configuration
- `variables.tf` - Input variables definition  
- `outputs.tf` - Output values
- `main.tf` - Infrastructure resources
- `user-data.sh` - Docker installation script
- `terraform.tfvars.example` - Example configuration
- `compartments.tf` - Compartment creation using the module

### Compartment Module
- `modules/compartment/main.tf` - Compartment, policies, and dynamic groups
- `modules/compartment/variables.tf` - Module input variables
- `modules/compartment/outputs.tf` - Module outputs
- `modules/compartment/README.md` - Module documentation

### Networking Module
- `modules/networking/main.tf` - VCN, subnets, security lists, and routing
- `modules/networking/variables.tf` - Module input variables
- `modules/networking/outputs.tf` - Module outputs
- `modules/networking/README.md` - Module documentation

### Docker Module
- `modules/docker/main.tf` - Compute instance with Docker installation
- `modules/docker/variables.tf` - Module input variables
- `modules/docker/outputs.tf` - Module outputs
- `modules/docker/README.md` - Module documentation

## Next Steps

1. **Set up CI/CD**: Connect this to your existing GitHub Actions or GitLab CI
2. **Add monitoring**: Consider adding CloudWatch or logging agents
3. **Scale out**: Use Auto Scaling for high-volume build workloads  
4. **Cost optimization**: Schedule instance shutdown during off-hours
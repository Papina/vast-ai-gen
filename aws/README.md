# AWS Infrastructure with Terraform and Packer

This directory contains a complete AWS infrastructure setup using Terraform for infrastructure provisioning and Packer for creating custom Debian AMIs.

## Architecture

- **VPC Module**: Creates a multi-AZ VPC with public and private subnets, NAT gateways, and security groups
- **Instance Module**: Provisions EC2 instances with configurable networking, storage, and security
- **Packer Configuration**: Builds custom Debian AMIs with Docker, development tools, and production optimizations

## Directory Structure

```
aws/
├── modules/
│   ├── vpc/           # VPC and networking module
│   └── instance/      # EC2 instance module
├── packer/
│   ├── debian.pkr.hcl # Packer configuration for Debian AMI
│   └── scripts/       # Packer provisioning scripts
│       ├── setup-users.sh
│       └── cleanup.sh
├── main.tf           # Main Terraform configuration
├── variables.tf      # Terraform variables
├── outputs.tf        # Terraform outputs
├── provider.tf       # AWS provider configuration
└── terraform.tfvars.example # Example configuration file
```

## Prerequisites

### AWS CLI and Terraform
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS credentials
aws configure --profile 333747696570_AdministratorAccess
# Enter your AWS Access Key ID, Secret Access Key, region, and output format

# Install Terraform
brew install terraform  # macOS
# or
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Packer
```bash
# Install Packer
brew install packer  # macOS
# or
wget https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip
unzip packer_1.9.4_linux_amd64.zip
sudo mv packer /usr/local/bin/
```

## Usage

### 1. Build Custom Debian AMI with Packer

```bash
cd aws/packer

# Initialize Packer
packer init .

# Build the AMI (ensure AWS credentials are configured)
packer build \
  -var="aws_region=us-east-1" \
  -var="project_name=my-debian-server" \
  -var="environment=production" \
  debian.pkr.hcl

# Note the AMI ID from the output
```

### 2. Configure Terraform

```bash
cd aws

# Copy example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Important: Update ami_id with the AMI ID from Packer output
```

### 3. Initialize and Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply

# Get outputs
terraform output
```

## Configuration

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `project_name` | Name of your project | "my-app" |
| `environment` | Environment name | "production" |
| `aws_region` | AWS region | "us-east-1" |
| `ami_id` | AMI ID for instances | "ami-0c02fb55956c7d316" |
| `key_name` | SSH key pair name | "my-keypair" |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `instance_count` | Number of instances | 2 |
| `instance_type` | EC2 instance type | "t3.micro" |
| `vpc_cidr` | VPC CIDR block | "10.0.0.0/16" |
| `public_subnet_cidrs` | Public subnet CIDRs | ["10.0.0.0/20", "10.0.16.0/20"] |
| `private_subnet_cidrs` | Private subnet CIDRs | ["10.0.128.0/20", "10.0.144.0/20"] |

## Features

### VPC Module
- Multi-AZ deployment for high availability
- Public and private subnets
- NAT gateways for outbound internet access
- Internet gateway for public internet access
- Security groups for SSH and web traffic
- Route tables with proper routing

### Instance Module
- Auto-scaling ready (configurable instance count)
- Key pair generation for SSH access
- Configurable instance types and storage
- Security group integration
- User data support for custom initialization
- Detailed tagging for cost allocation and organization

### Packer Configuration
- Based on official Debian 12 image
- Pre-installed Docker and Docker Compose
- Development tools (git, curl, vim, etc.)
- Production-ready optimizations
- Security hardening
- Automatic security updates
- Health monitoring scripts
- Automatic cleanup for smaller image size

## Outputs

After successful deployment, Terraform will provide:

- `vpc_id`: ID of the created VPC
- `public_subnet_ids`: IDs of public subnets
- `private_subnet_ids`: IDs of private subnets
- `instance_ids`: IDs of EC2 instances
- `instance_public_ips`: Public IP addresses
- `instance_private_ips`: Private IP addresses
- `instance_public_dns`: Public DNS names
- `ssh_security_group_id`: SSH security group ID
- `web_security_group_id`: Web traffic security group ID
- `key_pair_name`: Name of the created key pair

## Security Considerations

1. **Key Pairs**: Use your own SSH key pairs instead of the generated ones
2. **Security Groups**: Review and adjust security group rules for your use case
3. **Network ACLs**: Consider implementing network ACLs for additional security
4. **Encryption**: Enable encryption for volumes and data in transit
5. **Monitoring**: Implement CloudWatch monitoring and alerting
6. **Updates**: Keep the custom AMI updated with security patches

## Cost Optimization

1. **Instance Types**: Start with t3.micro for testing, scale as needed
2. **Storage**: Use gp3 volumes for better performance/cost ratio
3. **NAT Gateway Costs**: Consider VPC endpoints for AWS services to reduce NAT costs
4. **Reserved Instances**: Use reserved instances for production workloads
5. **Spot Instances**: Consider spot instances for fault-tolerant workloads

## Troubleshooting

### Common Issues

1. **AMI Not Found**: Ensure you've built the Packer AMI or use a valid AMI ID
2. **Key Pair Issues**: Verify your SSH key path and permissions
3. **Subnet Availability**: Check if availability zones support your instance types
4. **Network Connectivity**: Verify security group rules and route tables

### Debug Commands

```bash
# Check Terraform plan
terraform plan -detailed-exitcode

# Debug AWS provider
export TF_LOG=DEBUG
terraform apply

# Check Packer build logs
packer build -debug debian.pkr.hcl
```

## Cleanup

```bash
# Destroy infrastructure
terraform destroy

# Remove Packer AMI (manual process through AWS Console or CLI)
aws ec2 deregister-image --image-id ami-xxxxxxxxx
```

## Next Steps

1. **Load Balancing**: Add Application Load Balancer for high availability
2. **Auto Scaling**: Implement auto scaling groups based on metrics
3. **Database**: Add RDS for managed database services
4. **CDN**: Configure CloudFront for global content delivery
5. **Monitoring**: Set up CloudWatch alarms and dashboards
6. **CI/CD**: Integrate with CodePipeline/CodeDeploy for automated deployments
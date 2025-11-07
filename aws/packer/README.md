# Packer - Debian AMI Builder

This directory contains Packer configuration to build a custom Debian 13 AMI with Docker, Docker Compose, and other essential tools pre-installed.

## Prerequisites

- [Packer](https://www.packer.io/downloads) installed (version 1.7.0 or later)
- AWS credentials configured (via `~/.aws/credentials` or environment variables)
- Appropriate AWS IAM permissions to create EC2 instances and AMIs

## Installation

### Install Packer Plugins

Initialize Packer to download required plugins:

```bash
cd aws/packer
packer init debian.pkr.hcl
```

This will automatically install the AWS plugin specified in the configuration.

## Configuration

### Variables

The following variables can be customized in [`debian.pkr.hcl`](debian.pkr.hcl):

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `ap-southeast-2` | AWS region to build the AMI |
| `project_name` | `debian-server` | Project name for tagging |
| `environment` | `production` | Environment name for tagging |
| `debian_version` | `13` | Debian version |
| `instance_type` | `t3.micro` | EC2 instance type for building |
| `aws_source_ami` | `""` | Optional: Specific source AMI (auto-detected if empty) |

### Source AMI

The configuration automatically searches for the latest Debian 13 AMI matching the pattern `debian-13-amd64-2025*` from the official Debian AWS account (owner ID: `136693071363`).

To use a specific AMI instead, set the `aws_source_ami` variable.

## Usage

### Validate Configuration

Check if the Packer template is valid:

```bash
packer validate debian.pkr.hcl
```

### Build AMI

Build the AMI with default settings:

```bash
packer build debian.pkr.hcl
```

### Build with Custom Variables

Override variables using the `-var` flag:

```bash
packer build \
  -var 'project_name=my-project' \
  -var 'environment=staging' \
  -var 'instance_type=t3.small' \
  debian.pkr.hcl
```

### Using a Variables File

Create a `variables.pkrvars.hcl` file:

```hcl
aws_region   = "ap-southeast-2"
project_name = "my-project"
environment  = "production"
```

Then build with:

```bash
packer build -var-file=variables.pkrvars.hcl debian.pkr.hcl
```

## What Gets Installed

The AMI includes the following software:

### Container Runtime
- Docker CE (latest)
- Docker Compose (latest)
- containerd.io

### Development Tools
- Git
- curl, wget
- vim, nano
- htop
- jq
- unzip

### Programming Languages
- Python 3
- pip3
- python3-venv

### Web Server
- Nginx (enabled but stopped by default)

### User Configuration
- `admin` user added to docker group
- Passwordless sudo configured for `admin` user

## Scripts

The build process runs the following provisioning scripts:

1. **Inline shell commands** - Installs Docker, Docker Compose, and essential packages
2. [`scripts/setup-users.sh`](scripts/setup-users.sh) - Custom user setup
3. [`scripts/cleanup.sh`](scripts/cleanup.sh) - Cleanup and optimization

## Output

After a successful build:

- A new AMI will be created in your AWS account
- AMI name format: `{project_name}-{environment}-{timestamp}`
- A `manifest.json` file will be generated with build details

## Troubleshooting

### Plugin Installation Issues

If `packer init` fails, manually install the plugin:

```bash
packer plugins install github.com/hashicorp/amazon
```

### AWS Credentials

Ensure your AWS credentials are properly configured:

```bash
aws configure
```

Or set environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="ap-southeast-2"
```

### SSH Connection Issues

If Packer cannot connect via SSH, ensure:
- Your AWS security groups allow SSH (port 22)
- The source AMI uses the correct SSH username (`admin` for Debian)
- Your SSH key pair is properly configured

### AMI Not Found

If the automatic AMI search fails:
1. Verify the AMI name pattern matches available AMIs in your region
2. Check the owner ID is correct
3. Manually specify an AMI using the `aws_source_ami` variable

## Cleanup

To remove old AMIs and snapshots:

```bash
# List your AMIs
aws ec2 describe-images --owners self --region ap-southeast-2

# Deregister an AMI
aws ec2 deregister-image --image-id ami-xxxxx --region ap-southeast-2

# Delete associated snapshot
aws ec2 delete-snapshot --snapshot-id snap-xxxxx --region ap-southeast-2
```

## Additional Resources

- [Packer Documentation](https://www.packer.io/docs)
- [Packer AWS Builder](https://www.packer.io/plugins/builders/amazon)
- [Debian Official AMIs](https://wiki.debian.org/Cloud/AmazonEC2Image)

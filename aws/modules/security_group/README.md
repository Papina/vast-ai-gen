# Security Group Module

This Terraform module creates an AWS Security Group with SSH access (port 22) and customizable ingress rules.

## Features

- Creates a security group in a specified VPC
- SSH ingress rule (port 22) with configurable CIDR blocks
- Default egress rule allowing all outbound traffic
- Support for additional custom ingress rules
- Flexible tagging

## Usage

### Basic Example

```hcl
module "security_group" {
  source = "./modules/security_group"

  name   = "my-app"
  vpc_id = module.vpc.vpc.vpc_id

  ssh_allowed_cidrs = ["10.0.0.0/8"]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### With VPC Module

```hcl
module "vpc" {
  source = "./modules/network"
  # ... vpc configuration
}

module "security_group" {
  source = "./modules/security_group"

  name   = "web-server"
  vpc_id = module.vpc.vpc.vpc_id

  ssh_allowed_cidrs = ["203.0.113.0/24"]

  additional_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS"
    }
  ]

  tags = {
    Environment = "production"
    Application = "web"
  }
}
```

### Multiple Security Groups

```hcl
module "bastion_sg" {
  source = "./modules/security_group"

  name              = "bastion"
  vpc_id            = module.vpc.vpc.vpc_id
  ssh_allowed_cidrs = ["203.0.113.0/24"]
}

module "app_sg" {
  source = "./modules/security_group"

  name              = "application"
  vpc_id            = module.vpc.vpc.vpc_id
  ssh_allowed_cidrs = [module.vpc.vpc.cidr]

  additional_ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [module.vpc.vpc.cidr]
      description = "Allow app traffic from VPC"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for the security group | `string` | n/a | yes |
| vpc_id | VPC ID where the security group will be created | `string` | n/a | yes |
| description | Description for the security group | `string` | `"Security group managed by Terraform"` | no |
| ssh_allowed_cidrs | List of CIDR blocks allowed to SSH | `list(string)` | `["0.0.0.0/0"]` | no |
| tags | Additional tags for the security group | `map(string)` | `{}` | no |
| additional_ingress_rules | List of additional ingress rules | `list(object)` | `[]` | no |

### additional_ingress_rules Object

```hcl
{
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks = list(string)
  description = string
}
```

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the security group |
| security_group_name | Name of the security group |
| security_group_arn | ARN of the security group |
| vpc_id | VPC ID where the security group is created |

## Default Rules

### Ingress
- **SSH (22/tcp)**: Configurable CIDR blocks (default: `0.0.0.0/0`)
- **Additional rules**: As specified in `additional_ingress_rules`

### Egress
- **All traffic**: `0.0.0.0/0` (all protocols, all ports)

## Security Considerations

⚠️ **Warning**: The default SSH CIDR block is `0.0.0.0/0` (open to the internet). For production use, always restrict this to specific IP ranges:

```hcl
ssh_allowed_cidrs = ["203.0.113.0/24", "198.51.100.0/24"]
```

## Examples

### Restrict SSH to Corporate Network

```hcl
module "security_group" {
  source = "./modules/security_group"

  name              = "corporate-access"
  vpc_id            = module.vpc.vpc.vpc_id
  ssh_allowed_cidrs = ["203.0.113.0/24"]  # Corporate network only
}
```

### Database Security Group

```hcl
module "db_sg" {
  source = "./modules/security_group"

  name              = "database"
  vpc_id            = module.vpc.vpc.vpc_id
  ssh_allowed_cidrs = [module.vpc.vpc.cidr]  # SSH only from VPC

  additional_ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [module.vpc.vpc.private.subnet_cidrs[0]]
      description = "PostgreSQL from private subnet"
    }
  ]
}
```

## Notes

- Security group names are automatically suffixed with `-sg`
- All resources are tagged with `ManagedBy = "terraform"`
- The module creates separate rules for better flexibility and management
- Egress is unrestricted by default (best practice for most use cases)

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0

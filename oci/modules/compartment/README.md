# Compartment Module for Oracle Cloud Infrastructure

This module creates Oracle Cloud Infrastructure compartments with optional policies, dynamic groups, and default policies.

## Usage

### Basic Usage

```hcl
module "basic_compartment" {
  source = "./modules/compartment"

  compartment_name = "my-compartment"
  description      = "My custom compartment"
  parent_ocid      = "ocid1.tenancy.oc1.phx.xxxxxxxxxxxxxxxxx"
}
```

### Advanced Usage with Policies and Dynamic Group

```hcl
module "advanced_compartment" {
  source = "./modules/compartment"

  compartment_name      = "production"
  description          = "Production environment"
  parent_ocid          = "ocid1.tenancy.oc1.phx.xxxxxxxxxxxxxxxxx"
  enable_delete        = false
  create_default_policies = true
  
  # Create custom policies
  policies = [
    {
      name        = "developers-policy"
      description = "Policy for developers"
      statements  = [
        "Allow group Developers to read all-resources in compartment production",
        "Allow group Developers to use compute-instance-family in compartment production"
      ]
    }
  ]
  
  # Create dynamic group
  create_dynamic_group = true
  
  # Add tags
  tags = {
    environment = "production"
    team        = "platform"
  }
}
```

## Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `compartment_name` | string | yes | - | Name of the compartment (1-100 characters) |
| `description` | string | no | "Compartment created via Terraform" | Description of the compartment |
| `parent_ocid` | string | yes | - | OCID of the parent compartment |
| `enable_delete` | bool | no | true | Whether to allow deletion of the compartment |
| `tags` | map(string) | no | {} | Tags to apply to the compartment |
| `create_dynamic_group` | bool | no | false | Whether to create a dynamic group for this compartment |
| `policies` | list(object) | no | [] | List of policies to create for this compartment |
| `create_default_policies` | bool | no | false | Whether to create default policies for the compartment |

### Policies Object Structure

```hcl
policies = [
  {
    name        = string        # Name of the policy
    description = string        # Description of the policy
    statements  = list(string)  # List of policy statements
  }
]
```

## Outputs

| Output | Description |
|--------|-------------|
| `compartment_id` | OCID of the created compartment |
| `compartment_name` | Name of the created compartment |
| `compartment_description` | Description of the created compartment |
| `compartment_ocid` | Full OCID of the created compartment |
| `dynamic_group_id` | OCID of the created dynamic group (if created) |
| `dynamic_group_name` | Name of the created dynamic group (if created) |
| `policies` | Map of created policy OCIDs |
| `default_policies` | Map of created default policy OCIDs (if created) |

## Default Policies

When `create_default_policies` is set to true, the module creates three default policies:

1. **Compute Admin Policy**: For managing compute resources
2. **Storage Admin Policy**: For managing storage resources  
3. **Network Admin Policy**: For managing network resources

## Dynamic Groups

When `create_dynamic_group` is set to true, the module creates a dynamic group that matches all compute instances in the compartment. This is useful for IAM policies that need to allow instances to access OCI resources.

## Examples

### Development Environment

```hcl
module "dev_compartment" {
  source = "./modules/compartment"

  compartment_name      = "development"
  description          = "Development environment compartment"
  parent_ocid          = var.root_compartment_id
  create_default_policies = true
  
  tags = {
    environment = "development"
    cost_center = "engineering"
  }
}
```

### Staging Environment

```hcl
module "staging_compartment" {
  source = "./modules/compartment"

  compartment_name        = "staging"
  description            = "Staging environment compartment"
  parent_ocid            = module.dev_compartment.compartment_id
  create_dynamic_group   = true
  
  policies = [
    {
      name        = "ci-cd-policy"
      description = "Policy for CI/CD pipelines"
      statements  = [
        "Allow group CI-CD to manage compute-instance-family in compartment staging",
        "Allow group CI-CD to manage object-family in compartment staging"
      ]
    }
  ]
  
  tags = {
    environment = "staging"
    team        = "platform"
  }
}
```

### Production Environment (with restrictions)

```hcl
module "prod_compartment" {
  source = "./modules/compartment"

  compartment_name       = "production"
  description           = "Production environment compartment"
  parent_ocid           = var.root_compartment_id
  enable_delete         = false  # Protect production
  create_default_policies = true
  
  policies = [
    {
      name        = "production-operators"
      description = "Policy for production operators"
      statements  = [
        "Allow group ProductionOps to manage all-resources in compartment production"
      ]
    },
    {
      name        = "developers-read-only"
      description = "Read-only access for developers"
      statements  = [
        "Allow group Developers to read all-resources in compartment production"
      ]
    }
  ]
  
  tags = {
    environment = "production"
    compliance  = "sox"
    team        = "platform"
  }
}
```

## Notes

- The compartment name must be unique within the parent compartment
- Parent OCID is usually the root tenancy OCID for top-level compartments
- Deletion can be prevented by setting `enable_delete = false`
- Tags are useful for cost allocation and resource management
- Consider using different compartments for different environments (dev, staging, prod)
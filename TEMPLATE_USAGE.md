# Template Usage Guide

This document provides detailed instructions for customizing the AWS Terraform Module Template for your specific use case.

## Quick Start Checklist

### 1. Repository Setup

- [ ] Create repository from template
- [ ] Clone locally: `git clone <your-repo-url>`
- [ ] Open in VS Code/Cursor and install recommended extensions

### 2. Module Customization

- [ ] Update `main.tf` with your AWS resources
- [ ] Define variables in `variables.tf`
- [ ] Export outputs in `outputs.tf`
- [ ] Update module description in README.header.md

### 3. Examples & Documentation

- [ ] Create examples in `examples/` directories
- [ ] Update `.trivyignore` for any security exceptions
- [ ] Run `terraform-docs` to generate documentation

### 4. CI/CD Configuration (Optional)

- [ ] Configure AWS OIDC authentication
- [ ] Set repository variables for AWS access
- [ ] Test workflows with a sample commit

## Detailed Customization Steps

### Main Module Files

#### `main.tf` - Core Resources

Replace the example resources with your AWS service resources:

```hcl
# Example: S3 bucket module
resource "aws_s3_bucket" "this" {
  bucket = local.name_prefix
  tags   = local.default_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}
```

#### `variables.tf` - Input Variables

Define service-specific variables:

```hcl
variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be valid S3 bucket name."
  }
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket."
  type        = bool
  default     = true
}
```

#### `outputs.tf` - Resource Exports

Export all relevant resource attributes:

```hcl
output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name."
  value       = aws_s3_bucket.this.bucket_domain_name
}
```

### Examples Directory

Create meaningful examples that demonstrate your module usage:

#### `examples/00-basic/main.tf`

```hcl
module "s3_bucket" {
  source = "../.."

  name        = "my-basic-bucket"
  environment = "dev"

  # Basic configuration
  enable_versioning = true
  enable_encryption = true

  tags = {
    Project = "example"
    Owner   = "platform-team"
  }
}
```

#### `examples/10-advanced/main.tf`

```hcl
module "s3_bucket" {
  source = "../.."

  name        = "my-advanced-bucket"
  environment = "prod"

  # Advanced configuration
  enable_versioning = true
  enable_encryption = true

  lifecycle_rules = [
    {
      id     = "cleanup"
      status = "Enabled"

      expiration = {
        days = 90
      }
    }
  ]

  tags = {
    Project     = "production-app"
    Owner       = "platform-team"
    Environment = "prod"
    Backup      = "required"
  }
}
```

### Submodules (Optional)

If your module is complex, create submodules:

#### `submodules/bucket-policy/main.tf`

```hcl
resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = var.policy_document
}
```

#### `submodules/bucket-policy/variables.tf`

```hcl
variable "bucket_id" {
  description = "The ID of the S3 bucket."
  type        = string
}

variable "policy_document" {
  description = "The bucket policy document."
  type        = string
}
```

### Security Configuration

#### Update `.trivyignore`

Add specific exceptions for your module:

```
# S3 bucket allows public read access - acceptable for public content
AVD-AWS-0017

# Uses AWS managed encryption keys - acceptable for non-sensitive data
AVD-AWS-0132
```

### AWS OIDC Setup (CI/CD)

#### 1. Create OIDC Role in AWS

```hcl
# In your AWS account
resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsOIDCRole-terraform-modules"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:your-org/*:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
```

#### 2. Configure Repository Variables

In GitHub repository settings → Secrets and variables → Actions:

- `AWS_ACCOUNT_ID`: Your AWS account ID
- `AWS_REGION`: Default region (e.g., `us-east-1`)
- `AWS_OIDC_ROLE_NAME`: `GitHubActionsOIDCRole-terraform-modules`

### Documentation Generation

#### Update README Header

Modify `README.header.md` to describe your module:

```markdown
# Terraform AWS S3 Module

A production-ready Terraform module for creating and managing AWS S3 buckets with security best practices.

## Features

- **Security**: Encryption at rest and in transit by default
- **Versioning**: Configurable object versioning
- **Lifecycle**: Automated object lifecycle management
- **Access Control**: Flexible bucket policies and ACLs
```

#### Generate Documentation

```bash
# Auto-generate the full README
terraform-docs markdown table --output-file README.md .
```

## Testing Your Module

### Local Testing

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Lint code
tflint --recursive

# Security scan
trivy fs --config .trivy.yaml .

# Test example
cd examples/00-basic
terraform init
terraform plan
```

### CI/CD Testing

1. Push changes to a branch
2. Verify GitHub Actions workflows pass
3. Check the workflow summaries for any issues
4. Create a pull request to trigger PR automation

## Common Patterns

### Resource Naming

```hcl
locals {
  name_prefix = "${var.name}-${var.environment}"

  # For resources with strict naming requirements
  s3_bucket_name = replace(local.name_prefix, "_", "-")
}
```

### Conditional Resources

```hcl
resource "aws_s3_bucket_notification" "this" {
  count  = var.enable_notifications ? 1 : 0
  bucket = aws_s3_bucket.this.id

  # notification configuration
}
```

### Complex Variables

```hcl
variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket."
  type = list(object({
    id     = string
    status = string
    expiration = optional(object({
      days = number
    }))
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))
  }))
  default = []
}
```

### Validation Patterns

```hcl
variable "bucket_name" {
  description = "S3 bucket name."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be a valid S3 bucket name."
  }
}
```

## Troubleshooting

### Common Issues

1. **TFLint Errors**: Check `.tflint.hcl` configuration and rule compatibility
2. **Trivy Failures**: Review `.trivyignore` and add justified exceptions
3. **Example Validation**: Ensure examples have valid provider configuration
4. **AWS Authentication**: Verify OIDC role permissions and repository variables

### Debug Commands

```bash
# Check TFLint configuration
tflint --init
tflint --version

# Validate Terraform syntax
terraform validate

# Check terraform-docs output
terraform-docs --version
terraform-docs markdown table .
```

## Best Practices Summary

1. **Always validate inputs** with validation blocks
2. **Use consistent naming** with prefixes and conventions
3. **Tag all resources** with meaningful metadata
4. **Export comprehensive outputs** for downstream consumption
5. **Create realistic examples** that can be deployed
6. **Document security exceptions** in `.trivyignore`
7. **Test locally** before pushing changes
8. **Follow semantic versioning** in commit messages

## Template Updates

This template is based on proven patterns from production AWS modules. For updates:

1. Check the source repository for new patterns
2. Review AWS provider changelog for new features
3. Update Terraform and provider version constraints
4. Test changes with existing examples

---

For additional help, refer to the main README.md or consult the Terraform AWS Provider documentation.

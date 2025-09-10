# Main Terraform Configuration for AWS Module Template
# Replace this example with your actual AWS resources

# ================================
# LOCAL VALUES
# ================================

locals {
  # Common naming convention
  name_prefix = "${var.name}-${var.environment}"

  # Merge default tags with user-provided tags
  default_tags = merge(
    {
      Name        = var.name
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "aws-template" # Replace with your module name
    },
    var.tags
  )

  # Note: example_computed removed as it was unused
  # Add your computed values here as needed
}

# ================================
# DATA SOURCES
# ================================

# Get current AWS region
data "aws_region" "current" {}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Note: Add additional data sources here as needed for your module

# ================================
# EXAMPLE AWS RESOURCES
# ================================
# Replace this section with your actual AWS resources

# Example S3 bucket (replace with your resources)
resource "aws_s3_bucket" "example" {
  bucket = "${local.name_prefix}-example-bucket"

  tags = local.default_tags
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Example IAM role (replace with your resources)
resource "aws_iam_role" "example" {
  name = "${local.name_prefix}-example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.default_tags
}

# Example CloudWatch Log Group (conditional)
resource "aws_cloudwatch_log_group" "example" {
  count = var.enable_monitoring ? 1 : 0

  name              = "/aws/example/${local.name_prefix}"
  retention_in_days = 14

  tags = local.default_tags
}

# ================================
# VALIDATION RESOURCES
# ================================
# Use null_resource for module-level validations

resource "null_resource" "validate_configuration" {
  # Add lifecycle preconditions for complex validations
  lifecycle {
    precondition {
      condition     = var.example_config.count_limit > 0
      error_message = "Count limit must be greater than 0."
    }

    precondition {
      condition     = length(var.name) <= 20 || !var.enable_monitoring
      error_message = "When monitoring is enabled, name must be <= 20 characters to avoid resource name limits."
    }
  }
}

# ================================
# TEMPLATE NOTES
# ================================
#
# Main.tf Best Practices:
# 1. Use locals for computed values and naming conventions
# 2. Merge default tags with user tags using merge()
# 3. Use data sources for dynamic AWS information
# 4. Group related resources with comments
# 5. Use conditional resources with count/for_each
# 6. Include validation with null_resource and preconditions
# 7. Follow consistent naming patterns
# 8. Use meaningful resource names
#
# AWS Resource Patterns:
# - Always tag resources appropriately
# - Enable encryption by default where possible
# - Use least privilege IAM policies
# - Follow AWS naming conventions
# - Consider resource limits and quotas
# - Use data sources for dynamic values
#
# Remove this comment block in your actual module.

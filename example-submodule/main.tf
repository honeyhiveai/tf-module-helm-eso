# Example Submodule - Optional Component
# This demonstrates how to structure submodules within your main module
# Remove this directory if submodules are not needed for your use case

terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Example submodule resource
resource "aws_iam_policy" "example" {
  name        = "${var.name_prefix}-example-policy"
  description = var.policy_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.allowed_actions
        Resource = var.allowed_resources
      }
    ]
  })

  tags = var.tags
}

# Example of submodule calling another submodule
# module "nested_submodule" {
#   source = "../another-submodule"
#
#   # Pass variables to nested submodule
#   name_prefix = var.name_prefix
#   tags        = var.tags
# }

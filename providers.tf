# Terraform and Provider Version Requirements
# This file defines the minimum versions for Terraform and required providers

terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }

    # Add other providers as needed for your specific module
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.1"
    # }
    #
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 4.0"
    # }
  }
}

# AWS Provider Configuration
# Note: Avoid configuring provider settings in modules
# Let the root module/consumer configure the provider
# provider "aws" {
#   region = var.aws_region
#
#   default_tags {
#     tags = var.default_tags
#   }
# }

# Template Note:
# - Keep provider version constraints updated
# - Remove unused providers
# - Let consuming modules configure provider settings

# Provider configuration for advanced example

terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "terraform"
      Example     = "advanced"
      Project     = "terraform-module-template"
    }
  }
}

variable "aws_region" {
  description = "AWS region for resources."
  type        = string
  default     = "us-west-2"
}

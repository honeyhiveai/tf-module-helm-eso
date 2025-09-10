# Provider configuration for basic example

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
      Environment = "dev"
      ManagedBy   = "terraform"
      Example     = "basic"
    }
  }
}

variable "aws_region" {
  description = "AWS region for resources."
  type        = string
  default     = "us-east-1"
}

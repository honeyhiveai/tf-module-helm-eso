# Basic Example - AWS Terraform Module Template
# This example demonstrates the minimal configuration required to use this module

module "aws_example" {
  source = "../.."

  # Required variables
  name = "basic-example"

  # Optional variables with common settings
  environment = "dev"

  # Note: example_setting removed from template - add your actual variables here

  # Basic feature flags
  enable_monitoring = true
  enable_encryption = true

  # Tags
  tags = {
    Project = "terraform-module-template"
    Example = "basic"
    Owner   = "platform-team"
  }
}

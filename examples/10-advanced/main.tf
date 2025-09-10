# Advanced Example - AWS Terraform Module Template
# This example demonstrates advanced configuration with complex settings

module "aws_example" {
  source = "../.."

  # Required variables
  name = "advanced-example"

  # Environment configuration
  environment = "prod"
  # Note: aws_region removed from template - add back if your module uses it

  # Advanced configuration object
  example_config = {
    enabled     = true
    size        = "large"
    count_limit = 10
    settings = {
      feature_a = "enabled"
      feature_b = "disabled"
      timeout   = "30s"
    }
  }

  # Feature flags
  enable_monitoring = true
  enable_encryption = true

  # Comprehensive tagging
  tags = {
    Project     = "terraform-module-template"
    Example     = "advanced"
    Owner       = "platform-team"
    Environment = "prod"
    Backup      = "required"
    Compliance  = "sox"
    CostCenter  = "engineering"
  }
}

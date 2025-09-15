# External Role ESO Example
# Using externally managed IAM role for compliance/security requirements

module "eso" {
  source = "../.."

  # Required variables
  name         = "honeyhive"
  environment  = "prod"
  cluster_name = "honeyhive-prod-usw2"

  # External IAM Role Configuration
  create_iam_role       = false
  external_iam_role_arn = var.external_eso_role_arn

  # Authentication: Use Pod Identity with external role
  use_pod_identity = true

  # AWS Secrets Manager configuration
  enable_secrets_manager = true
  secrets_manager_arns = [
    "arn:aws:secretsmanager:us-west-2:123456789012:secret:honeyhive/database/*",
    "arn:aws:secretsmanager:us-west-2:123456789012:secret:honeyhive/api-keys/*"
  ]

  # AWS Parameter Store configuration
  enable_parameter_store = true
  parameter_store_arns = [
    "arn:aws:ssm:us-west-2:123456789012:parameter/honeyhive/config/*"
  ]

  # ESO configuration
  eso_version         = "0.9.11"
  controller_replicas = 2

  # Create the necessary cluster secret stores
  create_cluster_secret_store = true

  # Tags
  tags = {
    Project     = "HoneyHive"
    Layer       = "platform"
    Example     = "external-role"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# Output information about the external role setup
output "external_role_info" {
  description = "Information about the external role configuration"
  value = {
    external_role_arn = var.external_eso_role_arn
    role_created     = module.eso.iam_role_created
    auth_mode        = module.eso.authentication_mode
  }
}

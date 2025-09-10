# Basic ESO Example
# Minimal configuration for External Secrets Operator on EKS

module "eso" {
  source = "../.."

  # Required variables
  name         = "honeyhive"
  environment  = "dev"
  cluster_name = "honeyhive-dev-usw2"

  # AWS Secrets Manager configuration
  enable_secrets_manager = true
  secrets_manager_arns   = ["*"] # Allow access to all secrets - restrict in production

  # Optional: Parameter Store (disabled in basic example)
  enable_parameter_store = false

  # Basic ESO configuration
  eso_version         = "0.9.11"
  controller_replicas = 1

  # Create the necessary cluster secret stores
  create_cluster_secret_store = true

  # Tags
  tags = {
    Project   = "HoneyHive"
    Layer     = "platform"
    Example   = "basic"
    ManagedBy = "terraform"
  }
}

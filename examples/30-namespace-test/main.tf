# Namespace Test ESO Example
# Tests the new Helm-native namespace creation functionality
# This example demonstrates that the module works even when the namespace already exists

module "eso" {
  source = "../.."

  # Required variables
  name         = "honeyhive-namespace-test"
  environment  = "dev"
  cluster_name = "honeyhive-dev-usw2"

  # Use the default external-secrets namespace for testing
  namespace = "external-secrets"

  # Authentication: Use IRSA for Fargate workloads (default)
  use_pod_identity = false

  # AWS Secrets Manager configuration
  enable_secrets_manager = true
  secrets_manager_arns   = ["*"] # Allow access to all secrets - restrict in production

  # Optional: Parameter Store (enabled for comprehensive testing)
  enable_parameter_store   = true
  parameter_store_arns     = ["*"]

  # ESO configuration
  eso_version         = "0.9.11"
  controller_replicas = 1

  # Create the necessary cluster secret stores
  create_cluster_secret_store = true

  # Enable metrics for monitoring
  enable_metrics = true

  # Wait for rollout to complete
  wait_for_rollout = true

  # Tags
  tags = {
    Project   = "HoneyHive"
    Layer     = "platform"
    Example   = "namespace-test"
    ManagedBy = "terraform"
    Purpose   = "test-helm-namespace-creation"
  }
}

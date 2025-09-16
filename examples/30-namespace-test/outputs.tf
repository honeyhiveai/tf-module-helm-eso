# Outputs for Namespace Test ESO Example

output "eso_namespace" {
  description = "The Kubernetes namespace where ESO is deployed."
  value       = module.eso.namespace
}

output "eso_iam_role_arn" {
  description = "The ARN of the IAM role for ESO service account."
  value       = module.eso.eso_iam_role_arn
}

output "cluster_secret_store_secrets_manager" {
  description = "Name of the ClusterSecretStore for AWS Secrets Manager."
  value       = module.eso.cluster_secret_store_secrets_manager
}

output "cluster_secret_store_parameter_store" {
  description = "Name of the ClusterSecretStore for AWS Parameter Store."
  value       = module.eso.cluster_secret_store_parameter_store
}

output "helm_release_status" {
  description = "The status of the ESO Helm release."
  value       = module.eso.helm_release_status
}

output "module_configuration" {
  description = "Configuration summary of the ESO module."
  value       = module.eso.module_configuration
}

output "kubectl_commands" {
  description = "Useful kubectl commands for managing ESO."
  value = {
    get_pods          = module.eso.kubectl_get_pods_command
    get_secret_stores = module.eso.kubectl_get_secret_stores_command
    describe_eso      = module.eso.kubectl_describe_eso_command
  }
}

output "quick_start_guide" {
  description = "Quick start guide for using the deployed ESO instance."
  value       = module.eso.quick_start_guide
}

# Namespace test specific outputs
output "namespace_test_summary" {
  description = "Summary of namespace creation test results."
  value = {
    namespace_used        = module.eso.namespace
    helm_managed_creation = "true"
    test_purpose         = "Validate Helm-native namespace creation handles existing namespaces gracefully"
  }
}

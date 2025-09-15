# Outputs for Advanced ESO Example

output "eso_namespace" {
  description = "The Kubernetes namespace where ESO is deployed."
  value       = module.eso.namespace
}

output "eso_iam_role_arn" {
  description = "The ARN of the IAM role for ESO service account."
  value       = module.eso.eso_iam_role_arn
}

output "cluster_secret_stores" {
  description = "Names of the ClusterSecretStores created."
  value = {
    secrets_manager = module.eso.cluster_secret_store_secrets_manager
    parameter_store = module.eso.cluster_secret_store_parameter_store
  }
}

output "helm_release_status" {
  description = "The status of the ESO Helm release."
  value       = module.eso.helm_release_status
}

output "module_configuration" {
  description = "Configuration summary of the ESO module."
  value       = module.eso.module_configuration
}

output "features_enabled" {
  description = "Status of optional features in the ESO deployment."
  value       = module.eso.features_enabled
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
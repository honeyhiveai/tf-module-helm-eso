# Output Values for External Secrets Operator Terraform Module
# Export all relevant ESO resource attributes and connection information

# ================================
# ESO DEPLOYMENT INFO
# ================================

output "namespace" {
  description = "The Kubernetes namespace where ESO is deployed."
  value       = var.namespace
}

output "helm_release_name" {
  description = "The name of the ESO Helm release."
  value       = helm_release.external_secrets.name
}

output "helm_release_status" {
  description = "The status of the ESO Helm release."
  value       = helm_release.external_secrets.status
}

output "eso_version" {
  description = "The version of ESO that was deployed."
  value       = var.eso_version
}

# ================================
# IAM AND IRSA INFORMATION
# ================================

output "eso_iam_role_arn" {
  description = "The ARN of the IAM role for ESO service account (created or external)."
  value       = local.iam_role_arn
}

output "eso_iam_role_name" {
  description = "The name of the IAM role for ESO service account (if created by module)."
  value       = var.create_iam_role ? aws_iam_role.eso[0].name : null
}

output "iam_role_created" {
  description = "Whether the IAM role was created by this module or externally managed."
  value       = var.create_iam_role
}

output "service_account_name" {
  description = "The name of the Kubernetes service account for ESO."
  value       = local.service_account_name
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider (if created for IRSA)."
  value       = var.create_oidc_provider && !var.use_pod_identity ? aws_iam_openid_connect_provider.cluster[0].arn : null
}

output "pod_identity_association_arn" {
  description = "The ARN of the Pod Identity Association (if created by this module). Returns null if managed externally."
  value       = var.use_pod_identity && var.create_pod_identity_association ? try(aws_eks_pod_identity_association.eso[0].association_arn, null) : null
}

output "authentication_mode" {
  description = "The authentication mode being used (pod-identity or irsa)."
  value       = var.use_pod_identity ? "pod-identity" : "irsa"
}

# ================================
# CLUSTER SECRET STORES
# ================================

output "cluster_secret_store_secrets_manager" {
  description = "Name of the ClusterSecretStore for AWS Secrets Manager (if created)."
  value       = var.enable_secrets_manager && var.create_cluster_secret_store ? "aws-secrets-manager" : null
}

output "cluster_secret_store_parameter_store" {
  description = "Name of the ClusterSecretStore for AWS Parameter Store (if created)."
  value       = var.enable_parameter_store && var.create_cluster_secret_store ? "aws-parameter-store" : null
}

# ================================
# EKS CLUSTER INFORMATION
# ================================

output "cluster_name" {
  description = "The name of the EKS cluster where ESO is deployed."
  value       = var.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_version" {
  description = "The Kubernetes version of the EKS cluster."
  value       = data.aws_eks_cluster.cluster.version
}

# ================================
# AWS CONTEXT
# ================================

output "aws_region" {
  description = "The AWS region where secrets will be accessed."
  value       = var.aws_region != null ? var.aws_region : data.aws_region.current.id
}

output "aws_account_id" {
  description = "The current AWS account ID."
  value       = data.aws_caller_identity.current.account_id
}

# ================================
# CONFIGURATION SUMMARY
# ================================

output "module_configuration" {
  description = "Summary of the ESO module configuration."
  value = {
    name                         = var.name
    environment                  = var.environment
    namespace                    = var.namespace
    eso_version                  = var.eso_version
    controller_replicas          = var.controller_replicas
    secrets_manager_enabled      = var.enable_secrets_manager
    parameter_store_enabled      = var.enable_parameter_store
    cluster_secret_store_created = var.create_cluster_secret_store
    metrics_enabled              = var.enable_metrics
  }
}

# ================================
# COMPUTED VALUES
# ================================

output "name_prefix" {
  description = "The computed name prefix used for resource naming."
  value       = local.name_prefix
}

output "resource_tags" {
  description = "The tags applied to resources created by this module."
  value       = local.default_tags
}

# ================================
# ACCESS INFORMATION
# ================================

output "secrets_manager_arns" {
  description = "List of Secrets Manager ARNs that ESO can access."
  value       = var.secrets_manager_arns
}

output "parameter_store_arns" {
  description = "List of Parameter Store ARNs that ESO can access."
  value       = var.parameter_store_arns
}

# ================================
# KUBECTL COMMANDS
# ================================

output "kubectl_get_pods_command" {
  description = "Command to check ESO pod status."
  value       = "kubectl get pods -n ${var.namespace} -l app.kubernetes.io/name=external-secrets"
}

output "kubectl_get_secret_stores_command" {
  description = "Command to list all ClusterSecretStores."
  value       = "kubectl get clustersecretstores"
}

output "kubectl_describe_eso_command" {
  description = "Command to describe the ESO deployment."
  value       = "kubectl describe deployment external-secrets -n ${var.namespace}"
}

# ================================
# FEATURE STATUS
# ================================

output "features_enabled" {
  description = "Status of optional features in the ESO deployment."
  value = {
    secrets_manager       = var.enable_secrets_manager
    parameter_store       = var.enable_parameter_store
    cluster_secret_stores = var.create_cluster_secret_store
    metrics               = var.enable_metrics
    pod_identity          = var.use_pod_identity
    oidc_provider         = var.create_oidc_provider
    iam_role_created      = var.create_iam_role
  }
}

# ================================
# QUICK START GUIDE
# ================================

output "quick_start_guide" {
  description = "Quick start guide for using the deployed ESO instance."
  value = {
    check_status = "kubectl get pods -n ${var.namespace} -l app.kubernetes.io/name=external-secrets"
    list_stores  = "kubectl get clustersecretstores"
    example_external_secret = {
      apiVersion = "external-secrets.io/v1beta1"
      kind       = "ExternalSecret"
      metadata = {
        name      = "example-secret"
        namespace = "default"
      }
      spec = {
        refreshInterval = "15s"
        secretStoreRef = {
          name = var.enable_secrets_manager ? "aws-secrets-manager" : "aws-parameter-store"
          kind = "ClusterSecretStore"
        }
        target = {
          name = "example-secret"
        }
        data = [
          {
            secretKey = "password"
            remoteRef = {
              key = var.enable_secrets_manager ? "my-secret-name" : "/my/parameter/path"
            }
          }
        ]
      }
    }
  }
}
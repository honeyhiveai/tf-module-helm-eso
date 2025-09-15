# Outputs for External Role ESO Example

output "eso_namespace" {
  description = "The Kubernetes namespace where ESO is deployed."
  value       = module.eso.namespace
}

output "eso_iam_role_arn" {
  description = "The ARN of the external IAM role used by ESO."
  value       = module.eso.eso_iam_role_arn
}

output "authentication_mode" {
  description = "The authentication mode being used."
  value       = module.eso.authentication_mode
}

output "pod_identity_association_arn" {
  description = "The ARN of the Pod Identity Association."
  value       = module.eso.pod_identity_association_arn
}

output "cluster_secret_stores" {
  description = "Names of the ClusterSecretStores created."
  value = {
    secrets_manager  = module.eso.cluster_secret_store_secrets_manager
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

output "external_role_requirements" {
  description = "Requirements for the external IAM role."
  value = {
    trust_policy_note = "External role must trust either 'pods.eks.amazonaws.com' (Pod Identity) or the OIDC provider (IRSA)"
    required_permissions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue", 
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    example_trust_policy = {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "pods.eks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
          Condition = {
            ArnEquals = {
              "aws:SourceArn" = "arn:aws:eks:${var.aws_region}:*:podidentityassociation/${var.cluster_name}/*"
            }
          }
        }
      ]
    }
  }
}

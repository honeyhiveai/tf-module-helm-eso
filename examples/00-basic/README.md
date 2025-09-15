<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eso"></a> [eso](#module\_eso) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for resources. | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster. | `string` | `"honeyhive-dev-usw2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_secret_store_secrets_manager"></a> [cluster\_secret\_store\_secrets\_manager](#output\_cluster\_secret\_store\_secrets\_manager) | Name of the ClusterSecretStore for AWS Secrets Manager. |
| <a name="output_eso_iam_role_arn"></a> [eso\_iam\_role\_arn](#output\_eso\_iam\_role\_arn) | The ARN of the IAM role for ESO service account. |
| <a name="output_eso_namespace"></a> [eso\_namespace](#output\_eso\_namespace) | The Kubernetes namespace where ESO is deployed. |
| <a name="output_helm_release_status"></a> [helm\_release\_status](#output\_helm\_release\_status) | The status of the ESO Helm release. |
| <a name="output_kubectl_commands"></a> [kubectl\_commands](#output\_kubectl\_commands) | Useful kubectl commands for managing ESO. |
| <a name="output_module_configuration"></a> [module\_configuration](#output\_module\_configuration) | Configuration summary of the ESO module. |
| <a name="output_quick_start_guide"></a> [quick\_start\_guide](#output\_quick\_start\_guide) | Quick start guide for using the deployed ESO instance. |
<!-- END_TF_DOCS -->
# External Role ESO Example

This example demonstrates how to use the External Secrets Operator module with an **externally managed IAM role**. This approach is recommended for organizations that manage IAM roles centrally for compliance and security reasons.

## Use Cases

- **Centralized IAM Management**: Security teams manage all IAM roles
- **Compliance Requirements**: Roles must be created through specific processes
- **Role Reuse**: Using existing roles across multiple deployments
- **Separation of Concerns**: Infrastructure team manages Kubernetes, security team manages IAM

## External Role Requirements

Your externally managed IAM role must have:

### Trust Policy

For **Pod Identity** (recommended for EC2 workloads):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:eks:us-west-2:123456789012:podidentityassociation/honeyhive-prod-usw2/*"
        }
      }
    }
  ]
}
```

For **IRSA** (Fargate workloads):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE:sub": "system:serviceaccount:external-secrets:external-secrets",
          "oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
```

### Required Permissions

The role must have policies allowing:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "arn:aws:secretsmanager:*:*:secret:honeyhive/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:DescribeParameters"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/honeyhive/*"
    }
  ]
}
```

## Usage

```bash
# Set the external role ARN
export TF_VAR_external_eso_role_arn="arn:aws:iam::123456789012:role/HoneyHive-ESO-Role"

# Initialize and apply
terraform init
terraform plan
terraform apply
```

## Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| `external_eso_role_arn` | ARN of the externally managed IAM role | Required |
| `create_iam_role` | Set to `false` to use external role | `false` |
| `use_pod_identity` | Use Pod Identity (true) or IRSA (false) | `true` |

## Comparison with Other Examples

| Example | Role Management | Best For |
|---------|----------------|----------|
| Basic | Module creates role | Development, simple deployments |
| Advanced | Module creates role | Production with module-managed IAM |
| **External Role** | External role provided | Enterprise, compliance-driven environments |

## Verification

After deployment, verify the setup:

```bash
# Check ESO pods are running
kubectl get pods -n external-secrets

# Verify the service account
kubectl describe sa external-secrets -n external-secrets

# Check Pod Identity Association (if using Pod Identity)
aws eks describe-pod-identity-association \
  --cluster-name honeyhive-prod-usw2 \
  --association-arn $(terraform output -raw pod_identity_association_arn)

# Test secret access
kubectl apply -f - <<EOF
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: test-secret
  namespace: default
spec:
  refreshInterval: 15s
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: test-secret
  data:
  - secretKey: password
    remoteRef:
      key: honeyhive/database/password
EOF
```

## Troubleshooting

Common issues:

1. **Role Trust Policy**: Ensure the external role trusts the correct service
2. **Permissions**: Verify the role has access to the specified secret/parameter ARNs  
3. **Pod Identity**: Confirm the cluster has Pod Identity add-on enabled
4. **IRSA**: Check that OIDC provider exists and is configured correctly
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
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for resources | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | `"honeyhive-prod-usw2"` | no |
| <a name="input_external_eso_role_arn"></a> [external\_eso\_role\_arn](#input\_external\_eso\_role\_arn) | ARN of the externally managed IAM role for ESO | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authentication_mode"></a> [authentication\_mode](#output\_authentication\_mode) | The authentication mode being used. |
| <a name="output_cluster_secret_stores"></a> [cluster\_secret\_stores](#output\_cluster\_secret\_stores) | Names of the ClusterSecretStores created. |
| <a name="output_eso_iam_role_arn"></a> [eso\_iam\_role\_arn](#output\_eso\_iam\_role\_arn) | The ARN of the external IAM role used by ESO. |
| <a name="output_eso_namespace"></a> [eso\_namespace](#output\_eso\_namespace) | The Kubernetes namespace where ESO is deployed. |
| <a name="output_external_role_info"></a> [external\_role\_info](#output\_external\_role\_info) | Information about the external role configuration |
| <a name="output_external_role_requirements"></a> [external\_role\_requirements](#output\_external\_role\_requirements) | Requirements for the external IAM role. |
| <a name="output_features_enabled"></a> [features\_enabled](#output\_features\_enabled) | Status of optional features in the ESO deployment. |
| <a name="output_helm_release_status"></a> [helm\_release\_status](#output\_helm\_release\_status) | The status of the ESO Helm release. |
| <a name="output_kubectl_commands"></a> [kubectl\_commands](#output\_kubectl\_commands) | Useful kubectl commands for managing ESO. |
| <a name="output_module_configuration"></a> [module\_configuration](#output\_module\_configuration) | Configuration summary of the ESO module. |
| <a name="output_pod_identity_association_arn"></a> [pod\_identity\_association\_arn](#output\_pod\_identity\_association\_arn) | The ARN of the Pod Identity Association. |
<!-- END_TF_DOCS -->
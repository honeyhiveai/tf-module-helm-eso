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

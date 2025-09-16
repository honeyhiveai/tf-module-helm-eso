# ESO Namespace Test Example

This example tests the **new Helm-native namespace creation functionality** in the tf-module-helm-eso module. It demonstrates that the module now handles namespace creation idempotently through Helm's `create_namespace = true` feature, eliminating conflicts when the target namespace already exists.

## What This Tests

### Problem Addressed

Previously, the module used a separate `kubernetes_namespace` resource which could fail if the namespace already existed, causing deployment failures.

### Solution Implemented

- **Removed** separate `kubernetes_namespace` resource
- **Updated** `helm_release` to use `create_namespace = true`
- **Eliminated** conditional logic around namespace creation
- **Simplified** dependency management

## Key Features Tested

1. **Idempotent Namespace Creation**: Helm handles namespace creation gracefully whether it exists or not
2. **Comprehensive Secret Store Setup**: Tests both AWS Secrets Manager and Parameter Store integration
3. **Full IRSA Configuration**: Complete IAM role setup for service account authentication
4. **Metric Collection**: Enables monitoring capabilities
5. **Rollout Validation**: Waits for deployment completion

## Configuration Highlights

```hcl
module "eso" {
  source = "../.."

  # Uses default external-secrets namespace for testing
  namespace = "external-secrets"
  
  # Enables both secret backends
  enable_secrets_manager = true
  enable_parameter_store = true
  
  # Full monitoring and validation
  enable_metrics = true
  wait_for_rollout = true
}
```

## Usage

### Prerequisites

1. **EKS Cluster**: Running EKS cluster named `honeyhive-dev-usw2`
2. **AWS Credentials**: Configured with permissions for:
   - EKS cluster access
   - IAM role/policy management
   - Secrets Manager access
   - Parameter Store access
3. **kubectl**: Configured to access the target cluster

### Deployment

```bash
# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan

# Apply the configuration
terraform apply
```

### Test Scenarios

This example is designed to test multiple scenarios:

1. **Fresh Deployment**: Deploy to a cluster without existing external-secrets namespace
2. **Existing Namespace**: Deploy to a cluster where external-secrets namespace already exists
3. **Redeployment**: Run `terraform apply` multiple times to ensure idempotency

## Validation Commands

After deployment, verify the setup:

```bash
# Check namespace creation
kubectl get namespace external-secrets

# Verify ESO deployment
kubectl get pods -n external-secrets

# Check service account and IRSA configuration
kubectl describe serviceaccount external-secrets -n external-secrets

# Verify secret stores
kubectl get clustersecretstore

# Test secret retrieval (example)
kubectl apply -f - <<EOF
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: test-secret
  namespace: external-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: test-secret
    creationPolicy: Owner
  data:
  - secretKey: test
    remoteRef:
      key: test-secret-name
EOF
```

## Expected Outcomes

### Successful Deployment Indicators

- ✅ ESO pods running in `external-secrets` namespace
- ✅ Service account created with proper IRSA annotations
- ✅ ClusterSecretStore resources created for both Secrets Manager and Parameter Store
- ✅ Helm release shows `deployed` status
- ✅ No conflicts with existing namespace

### Troubleshooting

If deployment fails:

1. **Check cluster connectivity**:

   ```bash
   kubectl cluster-info
   ```

2. **Verify IAM permissions**:

   ```bash
   aws sts get-caller-identity
   ```

3. **Review Terraform state**:

   ```bash
   terraform show
   ```

4. **Check Helm release**:

   ```bash
   helm list -n external-secrets
   ```

## Cleanup

To remove all resources:

```bash
terraform destroy
```

## Key Changes from Previous Version

| Aspect | Before | After |
|--------|--------|-------|
| Namespace Creation | `kubernetes_namespace` resource | Helm `create_namespace = true` |
| Conditional Logic | `count = var.create_namespace ? 1 : 0` | Always enabled |
| Dependencies | Complex dependency chain | Simplified dependencies |
| Error Handling | Failed on existing namespace | Idempotent operation |
| Variables | Required `create_namespace` variable | Variable removed |

## Files in This Example

- `main.tf`: Module configuration with namespace testing focus
- `provider.tf`: Provider configurations and authentication setup
- `outputs.tf`: Comprehensive outputs including test-specific information
- `README.md`: This documentation

This example serves as both a test case and a reference implementation for the improved namespace handling in the ESO Terraform module.

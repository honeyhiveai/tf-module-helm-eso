# Service Account Creation Logic Verification

## Test Matrix

| Test Case | create_iam_role | use_pod_identity | Expected Behavior |
|-----------|----------------|------------------|-------------------|
| **IRSA + Module IAM** | `true` | `false` | Terraform creates SA, Helm skips |
| **Pod Identity + Module IAM** | `true` | `true` | Helm creates SA, Terraform skips |
| **Pod Identity + External IAM** | `false` | `true` | Helm creates SA, Terraform skips |
| **IRSA + External IAM** | `false` | `false` | Helm creates SA, Terraform skips |

## Logic Verification

### Terraform Service Account Count
```hcl
count = var.create_iam_role && !var.use_pod_identity ? 1 : 0
```

| create_iam_role | use_pod_identity | !use_pod_identity | create_iam_role && !use_pod_identity | Count |
|----------------|------------------|-------------------|-------------------------------------|-------|
| `true` | `false` | `true` | `true && true` = `true` | **1** ✅ |
| `true` | `true` | `false` | `true && false` = `false` | **0** ✅ |
| `false` | `true` | `false` | `false && false` = `false` | **0** ✅ |
| `false` | `false` | `true` | `false && true` = `false` | **0** ✅ |

### Helm Service Account Create
```hcl
create = var.create_iam_role && !var.use_pod_identity ? false : true
```

| create_iam_role | use_pod_identity | Condition Result | Helm Create |
|----------------|------------------|------------------|-------------|
| `true` | `false` | `true` → `false` | **false** ✅ |
| `true` | `true` | `false` → `true` | **true** ✅ |
| `false` | `true` | `false` → `true` | **true** ✅ |
| `false` | `false` | `false` → `true` | **true** ✅ |

### Helm Service Account Annotations
```hcl
annotations = !var.use_pod_identity ? {
  "eks.amazonaws.com/role-arn" = local.iam_role_arn
} : {}
```

| use_pod_identity | !use_pod_identity | Annotations |
|------------------|-------------------|-------------|
| `false` | `true` | **Role ARN** ✅ (IRSA needs it) |
| `true` | `false` | **Empty** ✅ (Pod Identity doesn't need it) |

## Mutual Exclusivity Verification

For each test case, verify that **exactly one** entity creates the service account:

1. **IRSA + Module IAM**: Terraform = 1, Helm = false ✅
2. **Pod Identity + Module IAM**: Terraform = 0, Helm = true ✅
3. **Pod Identity + External IAM**: Terraform = 0, Helm = true ✅
4. **IRSA + External IAM**: Terraform = 0, Helm = true ✅

**Result**: ✅ Exactly one entity creates the SA in all cases - no conflicts!

## Example Mapping

| Example | create_iam_role | use_pod_identity | SA Creator | Annotations |
|---------|----------------|------------------|------------|-------------|
| `00-basic` | `true` (default) | `false` | **Terraform** | Role ARN |
| `10-advanced` | `true` (default) | `true` | **Helm** | None |
| `20-external-role` | `false` | `true` | **Helm** | None |
| `30-namespace-test` | `true` (default) | `false` | **Terraform** | Role ARN |

All examples work correctly with the new logic! ✅

# External Secrets Operator Terraform Module - Main Configuration
# Deploys ESO on EKS with comprehensive AWS Secrets Manager integration

# ================================
# LOCAL VALUES
# ================================

locals {
  # Common naming convention
  name_prefix = "${var.name}-${var.environment}"

  # Merge default tags with user-provided tags
  default_tags = merge(
    {
      Name        = var.name
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "external-secrets-operator"
      Component   = "secrets-management"
    },
    var.tags
  )

  # Service account name for IRSA
  service_account_name = "external-secrets"

  # OIDC issuer URL from EKS cluster
  oidc_issuer_url = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")

  # IAM role ARN - use external role if provided, otherwise use created role
  iam_role_arn = var.create_iam_role ? aws_iam_role.eso[0].arn : var.external_iam_role_arn
}

# ================================
# DATA SOURCES
# ================================

# Get current AWS region
data "aws_region" "current" {}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get EKS cluster information
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

# Get TLS certificate for OIDC provider
data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# ================================
# NAMESPACE
# ================================
# Namespace will be created by Helm with create_namespace = true

# ================================
# IAM ROLE FOR SERVICE ACCOUNT (IRSA)
# ================================

# OIDC provider for EKS cluster (if not exists)
resource "aws_iam_openid_connect_provider" "cluster" {
  count = var.create_oidc_provider ? 1 : 0

  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]

  tags = local.default_tags
}

# IAM role for ESO service account
resource "aws_iam_role" "eso" {
  count = var.create_iam_role ? 1 : 0
  name  = "${local.name_prefix}-eso-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      var.use_pod_identity ? {
        # Pod Identity trust policy for EC2 workloads
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:podidentityassociation/${var.cluster_name}/*"
          }
        }
        } : {
        # IRSA trust policy for Fargate workloads
        Effect = "Allow"
        Principal = {
          Federated = var.create_oidc_provider ? aws_iam_openid_connect_provider.cluster[0].arn : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_issuer_url}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_issuer_url}:sub" = "system:serviceaccount:${var.namespace}:${local.service_account_name}"
            "${local.oidc_issuer_url}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = local.default_tags
}

# IAM policy for ESO to access AWS Secrets Manager and Parameter Store
resource "aws_iam_role_policy" "eso_secrets_access" {
  count = var.create_iam_role ? 1 : 0
  name  = "${local.name_prefix}-eso-secrets-policy"
  role  = aws_iam_role.eso[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      var.enable_secrets_manager ? [
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds",
            "secretsmanager:ListSecrets"
          ]
          Resource = var.secrets_manager_arns
        }
      ] : [],
      var.enable_parameter_store ? [
        {
          Effect = "Allow"
          Action = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath",
            "ssm:DescribeParameters"
          ]
          Resource = var.parameter_store_arns
        }
      ] : []
    )
  })
}

# ================================
# POD IDENTITY ASSOCIATION
# ================================

resource "aws_eks_pod_identity_association" "eso" {
  count = var.use_pod_identity ? 1 : 0

  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = local.service_account_name
  role_arn        = local.iam_role_arn

  tags = local.default_tags
}

# ================================
# SERVICE ACCOUNT
# ================================

resource "kubernetes_service_account" "eso" {
  metadata {
    name      = local.service_account_name
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "external-secrets"
      "app.kubernetes.io/instance"   = local.name_prefix
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/part-of"    = "external-secrets"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    # Only add IRSA annotation when not using Pod Identity
    annotations = var.use_pod_identity ? {} : {
      "eks.amazonaws.com/role-arn" = local.iam_role_arn
    }
  }

  # Service account no longer depends on separate namespace resource
}

# ================================
# EXTERNAL SECRETS OPERATOR HELM INSTALLATION
# ================================

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = var.eso_version
  namespace  = var.namespace

  create_namespace = true # Helm handles namespace creation idempotently
  timeout          = var.helm_timeout
  cleanup_on_fail  = true
  force_update     = false

  values = [
    yamlencode(merge({
      # Service Account configuration
      serviceAccount = {
        create = false
        name   = local.service_account_name
      }

      # Controller configuration
      replicaCount = var.controller_replicas

      # Resources
      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

      # Security context
      securityContext = {
        runAsNonRoot             = true
        runAsUser                = 65534
        allowPrivilegeEscalation = false
        readOnlyRootFilesystem   = true
        capabilities = {
          drop = ["ALL"]
        }
      }

      # Pod security context
      podSecurityContext = {
        fsGroup      = 65534
        runAsNonRoot = true
        runAsUser    = 65534
      }

      # Install CRDs
      installCRDs = true

      # Metrics
      metrics = {
        service = {
          enabled = var.enable_metrics
          port    = 8080
        }
      }

      # Webhook configuration
      webhook = {
        port = 9443
      }

      # Node selector and affinity
      nodeSelector = var.node_selector
      affinity     = var.affinity
      tolerations  = var.tolerations

    }, var.helm_values))
  ]

  depends_on = [
    kubernetes_service_account.eso
  ]
}

# ================================
# CLUSTER SECRET STORE
# ================================

resource "kubectl_manifest" "cluster_secret_store_sm" {
  count = var.enable_secrets_manager && var.create_cluster_secret_store ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "aws-secrets-manager"
      labels = {
        "app.kubernetes.io/name"       = "external-secrets"
        "app.kubernetes.io/instance"   = local.name_prefix
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.aws_region != null ? var.aws_region : data.aws_region.current.name
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = local.service_account_name
                namespace = var.namespace
              }
            }
          }
        }
      }
    }
  })

  depends_on = [helm_release.external_secrets]
}

resource "kubectl_manifest" "cluster_secret_store_ps" {
  count = var.enable_parameter_store && var.create_cluster_secret_store ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "aws-parameter-store"
      labels = {
        "app.kubernetes.io/name"       = "external-secrets"
        "app.kubernetes.io/instance"   = local.name_prefix
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      provider = {
        aws = {
          service = "ParameterStore"
          region  = var.aws_region != null ? var.aws_region : data.aws_region.current.name
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = local.service_account_name
                namespace = var.namespace
              }
            }
          }
        }
      }
    }
  })

  depends_on = [helm_release.external_secrets]
}

# ================================
# WAIT FOR DEPLOYMENT
# ================================

resource "null_resource" "wait_for_eso" {
  count = var.wait_for_rollout ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for External Secrets Operator to be ready..."
      kubectl wait --for=condition=available --timeout=300s deployment/external-secrets -n ${var.namespace}
      kubectl wait --for=condition=available --timeout=300s deployment/external-secrets-webhook -n ${var.namespace}
      echo "External Secrets Operator is ready!"
    EOT
  }

  depends_on = [helm_release.external_secrets]
}

# ================================
# VALIDATION RESOURCES
# ================================

resource "null_resource" "validate_configuration" {
  lifecycle {
    precondition {
      condition     = var.enable_secrets_manager || var.enable_parameter_store
      error_message = "At least one of Secrets Manager or Parameter Store must be enabled."
    }

    precondition {
      condition     = var.enable_secrets_manager == false || length(var.secrets_manager_arns) > 0
      error_message = "Secrets Manager ARNs must be provided when Secrets Manager is enabled."
    }

    precondition {
      condition     = var.enable_parameter_store == false || length(var.parameter_store_arns) > 0
      error_message = "Parameter Store ARNs must be provided when Parameter Store is enabled."
    }

    precondition {
      condition     = var.use_pod_identity == true || var.create_oidc_provider == true || data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer != null
      error_message = "When using IRSA (use_pod_identity=false), either create_oidc_provider must be true or OIDC provider must already exist on the cluster."
    }

    precondition {
      condition     = var.create_iam_role == true || var.external_iam_role_arn != null
      error_message = "When create_iam_role is false, external_iam_role_arn must be provided."
    }

    precondition {
      condition     = var.create_iam_role == false || var.external_iam_role_arn == null
      error_message = "Cannot specify external_iam_role_arn when create_iam_role is true. Choose either created or external role."
    }
  }
}


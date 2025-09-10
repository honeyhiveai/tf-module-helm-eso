# Advanced ESO Example
# Production-ready configuration with both Secrets Manager and Parameter Store

module "eso" {
  source = "../.."

  # Required variables
  name         = "honeyhive"
  environment  = "prod"
  cluster_name = "honeyhive-prod-usw2"

  # AWS region override
  aws_region = "us-west-2"

  # AWS Secrets Manager configuration
  enable_secrets_manager = true
  secrets_manager_arns = [
    "arn:aws:secretsmanager:us-west-2:123456789012:secret:honeyhive/database/*",
    "arn:aws:secretsmanager:us-west-2:123456789012:secret:honeyhive/api-keys/*",
    "arn:aws:secretsmanager:us-west-2:123456789012:secret:honeyhive/certificates/*"
  ]

  # AWS Parameter Store configuration
  enable_parameter_store = true
  parameter_store_arns = [
    "arn:aws:ssm:us-west-2:123456789012:parameter/honeyhive/config/*",
    "arn:aws:ssm:us-west-2:123456789012:parameter/honeyhive/feature-flags/*"
  ]

  # ESO configuration for production
  eso_version         = "0.9.11"
  controller_replicas = 2 # High availability

  # IRSA configuration
  create_oidc_provider = false # Assuming OIDC provider already exists

  # Kubernetes configuration
  create_namespace = true
  namespace       = "external-secrets"

  # Production helm values override
  helm_values = {
    resources = {
      limits = {
        cpu    = "1000m"
        memory = "1Gi"
      }
      requests = {
        cpu    = "500m"
        memory = "512Mi"
      }
    }
    
    # Pod disruption budget for high availability
    podDisruptionBudget = {
      enabled      = true
      minAvailable = 1
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
  }

  # Node selector for dedicated nodes
  node_selector = {
    "node.kubernetes.io/instance-type" = "t3.medium"
  }

  # Tolerations for dedicated nodes
  tolerations = [
    {
      key      = "dedicated"
      operator = "Equal"
      value    = "platform"
      effect   = "NoSchedule"
    }
  ]

  # Feature flags
  enable_metrics              = true
  create_cluster_secret_store = true
  wait_for_rollout           = true

  # Comprehensive tagging
  tags = {
    Project     = "HoneyHive"
    Layer       = "platform"
    Example     = "advanced"
    Environment = "prod"
    Backup      = "required"
    Compliance  = "sox"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}

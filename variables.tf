# Input Variables for External Secrets Operator Terraform Module
# Comprehensive configuration for ESO deployment on EKS

# ================================
# REQUIRED VARIABLES
# ================================

variable "name" {
  description = "Name prefix for all resources created by this module."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 63
    error_message = "Name must be between 1 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name))
    error_message = "Name must start and end with alphanumeric characters and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, test, stage, prod)."
  type        = string

  validation {
    condition = contains([
      "dev", "development",
      "test", "testing",
      "stage", "staging",
      "prod", "production"
    ], var.environment)
    error_message = "Environment must be one of: dev, development, test, testing, stage, staging, prod, production."
  }
}

variable "cluster_name" {
  description = "Name of the EKS cluster where External Secrets Operator will be deployed."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "Cluster name cannot be empty."
  }
}

# ================================
# AWS CONFIGURATION
# ================================

variable "aws_region" {
  description = "AWS region for secrets access. If not specified, uses current provider region."
  type        = string
  default     = null
}

variable "secrets_manager_arns" {
  description = "List of AWS Secrets Manager ARNs that ESO can access. Use ['*'] for all secrets."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.secrets_manager_arns :
      can(regex("^(arn:aws:secretsmanager:[a-z0-9-]+:[0-9]+:secret:[a-zA-Z0-9/_.-]+|\\*)$", arn))
    ])
    error_message = "Each Secrets Manager ARN must be valid or use '*' for all secrets."
  }
}

variable "parameter_store_arns" {
  description = "List of AWS Systems Manager Parameter Store ARNs that ESO can access. Use ['*'] for all parameters."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.parameter_store_arns :
      can(regex("^(arn:aws:ssm:[a-z0-9-]+:[0-9]+:parameter/.*|\\*)$", arn))
    ])
    error_message = "Each Parameter Store ARN must be valid or use '*' for all parameters."
  }
}

# ================================
# ESO CONFIGURATION
# ================================

variable "namespace" {
  description = "Kubernetes namespace for External Secrets Operator installation."
  type        = string
  default     = "external-secrets"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.namespace))
    error_message = "Namespace must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "eso_version" {
  description = "Version of the External Secrets Operator Helm chart to deploy."
  type        = string
  default     = "0.9.11"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.eso_version))
    error_message = "ESO version must be in semantic version format (e.g., 0.9.11)."
  }
}

variable "controller_replicas" {
  description = "Number of External Secrets Operator controller replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.controller_replicas >= 1 && var.controller_replicas <= 10
    error_message = "Controller replicas must be between 1 and 10."
  }
}

# ================================
# IRSA CONFIGURATION
# ================================

variable "create_oidc_provider" {
  description = "Whether to create the OIDC provider. Set to false if it already exists."
  type        = bool
  default     = false
}

# ================================
# SECRET STORE CONFIGURATION
# ================================

variable "enable_secrets_manager" {
  description = "Whether to enable AWS Secrets Manager integration."
  type        = bool
  default     = true
}

variable "enable_parameter_store" {
  description = "Whether to enable AWS Systems Manager Parameter Store integration."
  type        = bool
  default     = false
}

variable "create_cluster_secret_store" {
  description = "Whether to create ClusterSecretStore resources for AWS integration."
  type        = bool
  default     = true
}

# ================================
# HELM CHART CONFIGURATION
# ================================

variable "helm_values" {
  description = "Additional Helm values to override ESO chart defaults."
  type        = any
  default     = {}
}

variable "create_namespace" {
  description = "Whether to create the ESO namespace."
  type        = bool
  default     = true
}

variable "helm_timeout" {
  description = "Timeout for Helm chart installation (in seconds)."
  type        = number
  default     = 600

  validation {
    condition     = var.helm_timeout >= 300 && var.helm_timeout <= 1800
    error_message = "Helm timeout must be between 300 and 1800 seconds."
  }
}

# ================================
# KUBERNETES CONFIGURATION
# ================================

variable "node_selector" {
  description = "Node selector for ESO pods."
  type        = map(string)
  default     = {}
}

variable "affinity" {
  description = "Affinity settings for ESO pods."
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for ESO pods."
  type        = list(any)
  default     = []
}

# ================================
# RESOURCE MANAGEMENT
# ================================

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags :
      length(key) <= 128 && length(value) <= 256
    ])
    error_message = "Tag keys must be <= 128 characters and values <= 256 characters."
  }
}

# ================================
# FEATURE FLAGS
# ================================

variable "enable_metrics" {
  description = "Whether to enable Prometheus metrics for ESO."
  type        = bool
  default     = true
}

variable "wait_for_rollout" {
  description = "Whether to wait for ESO to be fully ready before completing deployment."
  type        = bool
  default     = true
}



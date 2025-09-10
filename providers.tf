# Terraform and Provider Version Requirements
# Required providers for External Secrets Operator Helm deployment on EKS

terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

# Provider Configuration Notes:
# - AWS provider: Used for IAM roles, OIDC providers, and data sources
# - Helm provider: For ESO chart installation
# - Kubernetes provider: For namespaces and service accounts
# - kubectl provider: For ClusterSecretStore CRDs
# - TLS provider: For OIDC certificate validation
# - Let the root module configure provider settings and authentication

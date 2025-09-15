# Variables for External Role Example

variable "external_eso_role_arn" {
  description = "ARN of the externally managed IAM role for ESO"
  type        = string
  
  # Example: "arn:aws:iam::123456789012:role/HoneyHive-ESO-Role"
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.external_eso_role_arn))
    error_message = "Must be a valid IAM role ARN."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "honeyhive-prod-usw2"
}

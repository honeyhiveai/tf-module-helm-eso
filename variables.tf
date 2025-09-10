# Input Variables for AWS Terraform Module Template
# This file contains common patterns and examples for AWS module variables

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

# ================================
# COMMON AWS PATTERNS
# ================================

# Note: Add region-specific variables here if your module needs them

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"

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
# MODULE-SPECIFIC VARIABLES
# ================================
# Replace this section with variables specific to your AWS service/resource

# Note: Add your module-specific variables here

variable "example_config" {
  description = "Example complex configuration object. Replace with actual module configuration."
  type = object({
    enabled     = optional(bool, true)
    size        = optional(string, "small")
    settings    = optional(map(string), {})
    count_limit = optional(number, 5)
  })
  default = {}

  validation {
    condition     = var.example_config.count_limit >= 1 && var.example_config.count_limit <= 100
    error_message = "Count limit must be between 1 and 100."
  }
}

# ================================
# FEATURE FLAGS
# ================================

variable "enable_monitoring" {
  description = "Whether to enable monitoring and logging features."
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Whether to enable encryption for applicable resources."
  type        = bool
  default     = true
}

# ================================
# TEMPLATE NOTES
# ================================
#
# Variable Best Practices:
# 1. Always include description and type
# 2. Use validation blocks for constrained values
# 3. Provide sensible defaults for optional variables
# 4. Group related variables with comments
# 5. Use consistent naming conventions (snake_case)
# 6. Document complex object types clearly
# 7. Consider using optional() for flexible configurations
#
# Common AWS Variable Patterns:
# - Resource naming (name, prefix, suffix)
# - Tagging (tags, default_tags)
# - Region and AZ selection
# - Security settings (encryption, access control)
# - Feature toggles (enable_*)
# - Sizing and scaling parameters
# - Network configuration (subnets, security groups)
#
# Remove this comment block in your actual module.

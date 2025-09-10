# Variables for Example Submodule

variable "name_prefix" {
  description = "Name prefix for resources created by this submodule."
  type        = string
}

variable "policy_description" {
  description = "Description for the IAM policy."
  type        = string
  default     = "Example IAM policy created by submodule"
}

variable "allowed_actions" {
  description = "List of allowed IAM actions."
  type        = list(string)
  default     = ["s3:GetObject"]

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "At least one action must be specified."
  }
}

variable "allowed_resources" {
  description = "List of allowed resource ARNs."
  type        = list(string)
  default     = ["*"]
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

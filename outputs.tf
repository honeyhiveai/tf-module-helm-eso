# Output Values for AWS Terraform Module Template
# Export all relevant resource attributes that consumers might need

# ================================
# RESOURCE IDENTIFIERS
# ================================

output "example_bucket_id" {
  description = "The ID/name of the example S3 bucket."
  value       = aws_s3_bucket.example.id
}

output "example_bucket_arn" {
  description = "The ARN of the example S3 bucket."
  value       = aws_s3_bucket.example.arn
}

output "example_role_arn" {
  description = "The ARN of the example IAM role."
  value       = aws_iam_role.example.arn
}

output "example_role_name" {
  description = "The name of the example IAM role."
  value       = aws_iam_role.example.name
}

# ================================
# CONDITIONAL OUTPUTS
# ================================

output "log_group_name" {
  description = "The name of the CloudWatch log group (if monitoring is enabled)."
  value       = var.enable_monitoring ? aws_cloudwatch_log_group.example[0].name : null
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group (if monitoring is enabled)."
  value       = var.enable_monitoring ? aws_cloudwatch_log_group.example[0].arn : null
}

# ================================
# COMPUTED VALUES
# ================================

output "name_prefix" {
  description = "The computed name prefix used for resource naming."
  value       = local.name_prefix
}

output "region" {
  description = "The AWS region where resources were created."
  value       = data.aws_region.current.name
}

output "account_id" {
  description = "The AWS account ID where resources were created."
  value       = data.aws_caller_identity.current.account_id
}

# ================================
# CONFIGURATION SUMMARY
# ================================

output "module_configuration" {
  description = "Summary of the module configuration."
  value = {
    name               = var.name
    environment        = var.environment
    monitoring_enabled = var.enable_monitoring
    encryption_enabled = var.enable_encryption
    region             = data.aws_region.current.name
  }
}

# ================================
# RESOURCE COLLECTIONS
# ================================
# Useful when module creates multiple similar resources

output "all_resource_arns" {
  description = "ARNs of all major resources created by this module."
  value = compact([
    aws_s3_bucket.example.arn,
    aws_iam_role.example.arn,
    var.enable_monitoring ? aws_cloudwatch_log_group.example[0].arn : null,
  ])
}

output "resource_tags" {
  description = "The tags applied to resources created by this module."
  value       = local.default_tags
}

# ================================
# TEMPLATE NOTES
# ================================
#
# Output Best Practices:
# 1. Always include description for every output
# 2. Export all resource IDs, ARNs, and names consumers might need
# 3. Use try() for conditional resources to avoid errors
# 4. Group related outputs with comments
# 5. Include computed values that might be useful
# 6. Export configuration summaries for visibility
# 7. Use consistent naming conventions
# 8. Consider what downstream modules/resources might need
#
# Common AWS Output Patterns:
# - Resource ARNs (for cross-resource references)
# - Resource IDs/names (for resource dependencies)
# - DNS names and endpoints
# - Security group IDs
# - Subnet IDs and CIDR blocks
# - IAM role ARNs and names
# - Configuration summaries
#
# Remove this comment block in your actual module.

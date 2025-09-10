# Outputs for Advanced Example

output "all_resource_arns" {
  description = "ARNs of all resources created by the module."
  value       = module.aws_example.all_resource_arns
}

output "example_bucket_id" {
  description = "The ID of the example S3 bucket."
  value       = module.aws_example.example_bucket_id
}

output "example_bucket_arn" {
  description = "The ARN of the example S3 bucket."
  value       = module.aws_example.example_bucket_arn
}

output "example_role_arn" {
  description = "The ARN of the example IAM role."
  value       = module.aws_example.example_role_arn
}

output "log_group_name" {
  description = "The name of the CloudWatch log group (if enabled)."
  value       = module.aws_example.log_group_name
}

output "module_configuration" {
  description = "Complete configuration summary of the module."
  value       = module.aws_example.module_configuration
}

output "resource_tags" {
  description = "Tags applied to all resources."
  value       = module.aws_example.resource_tags
}

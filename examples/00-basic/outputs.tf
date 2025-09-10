# Outputs for Basic Example

output "example_bucket_id" {
  description = "The ID of the example S3 bucket."
  value       = module.aws_example.example_bucket_id
}

output "example_bucket_arn" {
  description = "The ARN of the example S3 bucket."
  value       = module.aws_example.example_bucket_arn
}

output "module_configuration" {
  description = "Configuration summary of the module."
  value       = module.aws_example.module_configuration
}

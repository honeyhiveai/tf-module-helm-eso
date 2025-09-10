# Outputs for Example Submodule

output "policy_arn" {
  description = "The ARN of the created IAM policy."
  value       = aws_iam_policy.example.arn
}

output "policy_name" {
  description = "The name of the created IAM policy."
  value       = aws_iam_policy.example.name
}

output "policy_id" {
  description = "The ID of the created IAM policy."
  value       = aws_iam_policy.example.id
}

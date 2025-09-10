# TFLint Configuration for AWS Terraform Modules
# Generic configuration suitable for any AWS Terraform module

# Plugin configuration
plugin "terraform" {
  enabled = true
  version = "0.7.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "aws" {
  enabled = true
  version = "0.32.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Global configuration
config {
  # Enable all rules by default
  disabled_by_default = false

  # Call module in parallel for faster execution
  call_module_type = "all"
}

# Terraform core rules (stable across versions)
rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

# AWS-specific rules - conservative set that works across AWS services
rule "aws_instance_previous_type" {
  enabled = false # Too restrictive for modules
}

rule "aws_db_instance_previous_type" {
  enabled = false # Too restrictive for modules
}

# Note: Additional AWS rules can be enabled based on specific module needs
# See: https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/rules/README.md

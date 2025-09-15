# AWS Terraform Module Template

[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.8.0-623CE4)](https://github.com/hashicorp/terraform)
[![AWS Provider](https://img.shields.io/badge/AWS-%7E%3E%206.0-orange)](https://registry.terraform.io/providers/hashicorp/aws/latest)

A production-ready template for creating AWS Terraform modules with comprehensive development tooling, testing, and CI/CD workflows.

> **🚀 Getting Started**: This is a template repository. See [How to Use This Template](#how-to-use-this-template) below for setup instructions.

## Template Features

### 🏗️ **Development Environment**

- **IDE Configuration**: Pre-configured VS Code/Cursor settings for optimal Terraform development
- **Code Quality**: TFLint with AWS-specific rules and terraform-docs integration
- **Security Scanning**: Trivy security analysis with configurable policies
- **Auto-formatting**: Consistent code formatting with EditorConfig and Terraform fmt

### 🔄 **CI/CD Workflows**

- **Branch Validation**: Automated testing on all branches except main
- **Pull Request Automation**: Auto-formatting and semantic version validation
- **Release Management**: Automated semantic versioning and GitHub releases
- **Example Testing**: Validation of all example configurations

### 📚 **Documentation & Examples**

- **Comprehensive Documentation**: Auto-generated with terraform-docs
- **Example Configurations**: Template structure for common usage patterns
- **Submodule Support**: Optional submodule structure for complex modules
- **Usage Guidelines**: Complete setup and customization instructions

## How to Use This Template

### 1. Create Repository from Template

1. Click "Use this template" on GitHub or clone this repository
2. Choose a name following the pattern: `terraform-module-aws-<service>`
3. Clone your new repository locally

### 2. Customize Your Module

Replace the example AWS resources in `main.tf` with your actual resources:

```bash
# Example: Creating an S3 module
sed -i 's/aws-template/aws-s3/g' main.tf
sed -i 's/Example/S3 Bucket/g' variables.tf outputs.tf
```

### 3. Update Configuration

1. **Module Information**: Update `main.tf`, `variables.tf`, and `outputs.tf`
2. **Documentation**: Modify this README header with your module's purpose
3. **Examples**: Create meaningful examples in the `examples/` directory
4. **Variables**: Define your module's specific input variables
5. **Outputs**: Export all relevant resource attributes

### 4. Configure AWS Authentication (Optional)

If using AWS OIDC for CI/CD, set these repository variables:

- `AWS_ACCOUNT_ID`: Your AWS account ID
- `AWS_REGION`: Default region (e.g., `us-east-1`)
- `AWS_OIDC_ROLE_NAME`: GitHub Actions OIDC role name

### 5. Development Setup

This repository includes comprehensive IDE configuration and development tools:

#### 🚀 **Getting Started**

1. **Clone and Open**: Clone the repository and open it in Cursor/VS Code
2. **Install Extensions**: Accept the prompt to install recommended extensions
3. **Verify Setup**: Run `Ctrl+Shift+P` → "Tasks: Run Task" → "Run All Quality Checks"

#### 🛠️ **Available Development Tools**

| Tool                   | Purpose                           | Command                                                         |
| ---------------------- | --------------------------------- | --------------------------------------------------------------- |
| **Terraform Format**   | Auto-format all `.tf` files       | `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform: Format"        |
| **Terraform Validate** | Validate configuration syntax     | `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform: Validate"      |
| **TFLint Check**       | Code quality and best practices   | `Ctrl+Shift+P` → "Tasks: Run Task" → "TFLint: Check"            |
| **Security Scan**      | Trivy security vulnerability scan | `Ctrl+Shift+P` → "Tasks: Run Task" → "Trivy: Security Scan"     |
| **Generate Docs**      | Update README with terraform-docs | `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform Docs: Generate" |
| **All Quality Checks** | Run complete validation pipeline  | `Ctrl+Shift+P` → "Tasks: Run Task" → "Run All Quality Checks"   |

#### ⚙️ **IDE Features Configured**

- **Auto-formatting** on save for all Terraform files
- **Enhanced validation** with Terraform Language Server
- **Code completion** and IntelliSense for Terraform resources
- **File associations** for `.tf`, `.tfvars`, and `.hcl` files
- **Performance optimizations** (excluded `.terraform` directories from indexing)
- **Consistent formatting** across all file types via EditorConfig

#### 📋 **Code Quality Standards**

The repository enforces these standards automatically:

- **TFLint**: Terraform best practices and AWS-specific rules
- **Trivy**: Security vulnerability scanning
- **terraform-docs**: Automatic documentation generation
- **Formatting**: Consistent 2-space indentation for Terraform files
- **Validation**: Comprehensive variable validation and preconditions

#### 🔧 **Manual Commands**

For developers preferring command-line workflow:

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Run linting
tflint --recursive

# Security scan
trivy fs --config .trivy.yaml .

# Generate documentation
terraform-docs markdown table --output-file README.md .
```

## Template Structure

```
terraform-module-aws-<service>/
├── .cursorrules                    # Development guidelines and best practices
├── .editorconfig                   # Cross-editor formatting consistency
├── .gitignore                      # Standard Terraform gitignore
├── .terraform-docs.yml             # Documentation generation config
├── .tflint.hcl                     # Terraform linting configuration
├── .trivy.yaml                     # Security scanning configuration
├── .trivyignore                    # Security exceptions (customize as needed)
├── .vscode/                        # VS Code/Cursor IDE configuration
│   ├── settings.json               # Terraform-optimized settings
│   ├── extensions.json             # Recommended extensions
│   └── tasks.json                  # Pre-configured development tasks
├── .cursor/                        # Cursor-specific workspace settings
├── .github/workflows/              # CI/CD automation
│   ├── branch_validation.yml       # Quality checks and testing
│   ├── pull_request.yml            # PR automation and formatting
│   └── tag_and_release.yml         # Semantic versioning and releases
├── providers.tf                    # Terraform and provider requirements
├── main.tf                         # Main module resources (customize this)
├── variables.tf                    # Input variables (customize this)
├── outputs.tf                      # Output values (customize this)
├── examples/                       # Usage examples (add your examples)
│   ├── 00-basic/                   # Basic usage example
│   └── 10-advanced/                # Advanced configuration example
├── submodules/                     # Optional submodules (if needed)
│   └── example-submodule/          # Example submodule structure
└── README.md                       # Auto-generated documentation
```

## Customization Checklist

- [ ] Replace example resources in `main.tf` with your AWS service resources
- [ ] Update `variables.tf` with service-specific input variables
- [ ] Update `outputs.tf` with relevant resource attributes
- [ ] Modify this README header to describe your module's purpose
- [ ] Create meaningful examples in `examples/` directories
- [ ] Update `.trivyignore` with any necessary security exceptions
- [ ] Configure AWS OIDC authentication (if using CI/CD with AWS)
- [ ] Test the module with `terraform plan` and `terraform apply`
- [ ] Run `terraform-docs` to generate final documentation

## Module Development Best Practices

This template follows AWS and Terraform best practices:

### 🏗️ **Resource Management**

- Use consistent naming conventions with prefixes
- Apply comprehensive tagging to all resources
- Enable encryption by default where applicable
- Follow least privilege principles for IAM

### 📝 **Code Quality**

- Include validation blocks for all constrained variables
- Use descriptive variable and output names
- Document complex logic with inline comments
- Export all resource attributes consumers might need

### 🧪 **Testing & Validation**

- Create realistic examples that can be deployed
- Include both basic and advanced usage scenarios
- Validate examples with `terraform plan` in CI/CD
- Test edge cases and error conditions

### 🔒 **Security**

- Scan for misconfigurations with Trivy
- Review and document security exceptions
- Follow AWS security best practices
- Enable logging and monitoring where applicable

## Template Maintenance

This template is based on the patterns from `tf-module-aws-vpc` and includes:

- **Terraform**: >=1.8.0 with AWS Provider ~>6.0
- **Module Architecture**: Hierarchical with optional submodules
- **Documentation**: terraform-docs with auto-generation
- **Testing**: Example configurations with validation
- **Security**: Trivy scanning with configurable ignore rules
- **Versioning**: Semantic versioning with GitHub Actions automation

## Support

For questions about this template or AWS Terraform module development:

1. Review the [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
2. Check the [Terraform Module Development Guide](https://developer.hashicorp.com/terraform/language/modules/develop)
3. See example implementations in existing AWS modules

---

**Template Version**: 1.0.0
**Last Updated**: 2024
**Based on**: tf-module-aws-vpc patterns and best practices


<!-- BEGIN_TF_DOCS -->
# AWS Terraform Module Template

[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.8.0-623CE4)](https://github.com/hashicorp/terraform)
[![AWS Provider](https://img.shields.io/badge/AWS-%7E%3E%206.0-orange)](https://registry.terraform.io/providers/hashicorp/aws/latest)

A production-ready template for creating AWS Terraform modules with comprehensive development tooling, testing, and CI/CD workflows.

> **🚀 Getting Started**: This is a template repository. See [How to Use This Template](#how-to-use-this-template) below for setup instructions.

## Template Features

### 🏗️ **Development Environment**

- **IDE Configuration**: Pre-configured VS Code/Cursor settings for optimal Terraform development
- **Code Quality**: TFLint with AWS-specific rules and terraform-docs integration
- **Security Scanning**: Trivy security analysis with configurable policies
- **Auto-formatting**: Consistent code formatting with EditorConfig and Terraform fmt

### 🔄 **CI/CD Workflows**

- **Branch Validation**: Automated testing on all branches except main
- **Pull Request Automation**: Auto-formatting and semantic version validation
- **Release Management**: Automated semantic versioning and GitHub releases
- **Example Testing**: Validation of all example configurations

### 📚 **Documentation & Examples**

- **Comprehensive Documentation**: Auto-generated with terraform-docs
- **Example Configurations**: Template structure for common usage patterns
- **Submodule Support**: Optional submodule structure for complex modules
- **Usage Guidelines**: Complete setup and customization instructions

## How to Use This Template

### 1. Create Repository from Template

1. Click "Use this template" on GitHub or clone this repository
2. Choose a name following the pattern: `terraform-module-aws-<service>`
3. Clone your new repository locally

### 2. Customize Your Module

Replace the example AWS resources in `main.tf` with your actual resources:

```bash
# Example: Creating an S3 module
sed -i 's/aws-template/aws-s3/g' main.tf
sed -i 's/Example/S3 Bucket/g' variables.tf outputs.tf
```

### 3. Update Configuration

1. **Module Information**: Update `main.tf`, `variables.tf`, and `outputs.tf`
2. **Documentation**: Modify this README header with your module's purpose
3. **Examples**: Create meaningful examples in the `examples/` directory
4. **Variables**: Define your module's specific input variables
5. **Outputs**: Export all relevant resource attributes

### 4. Configure AWS Authentication (Optional)

If using AWS OIDC for CI/CD, set these repository variables:

- `AWS_ACCOUNT_ID`: Your AWS account ID
- `AWS_REGION`: Default region (e.g., `us-east-1`)
- `AWS_OIDC_ROLE_NAME`: GitHub Actions OIDC role name

### 5. Development Setup

This repository includes comprehensive IDE configuration and development tools:

#### 🚀 **Getting Started**

1. **Clone and Open**: Clone the repository and open it in Cursor/VS Code
2. **Install Extensions**: Accept the prompt to install recommended extensions
3. **Verify Setup**: Run `Ctrl+Shift+P` → "Tasks: Run Task" → "Run All Quality Checks"

#### 🛠️ **Available Development Tools**

| Tool                   | Purpose                           | Command                                                         |
| ---------------------- | --------------------------------- | --------------------------------------------------------------- |
| **Terraform Format**   | Auto-format all `.tf` files       | `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform: Format"        |
| **Terraform Validate** | Validate configuration syntax     | `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform: Validate"      |
| **TFLint Check**       | Code quality and best practices   | `Ctrl+Shift+P` → "Tasks: Run Task" → "TFLint: Check"            |
| **Security Scan**      | Trivy security vulnerability scan | `Ctrl+Shift+P` → "Tasks: Run Task" → "Trivy: Security Scan"     |
| **Generate Docs**      | Update README with terraform-docs | `Ctrl+Shift+P` → "Tasks: Run Task" → "Terraform Docs: Generate" |
| **All Quality Checks** | Run complete validation pipeline  | `Ctrl+Shift+P` → "Tasks: Run Task" → "Run All Quality Checks"   |

#### ⚙️ **IDE Features Configured**

- **Auto-formatting** on save for all Terraform files
- **Enhanced validation** with Terraform Language Server
- **Code completion** and IntelliSense for Terraform resources
- **File associations** for `.tf`, `.tfvars`, and `.hcl` files
- **Performance optimizations** (excluded `.terraform` directories from indexing)
- **Consistent formatting** across all file types via EditorConfig

#### 📋 **Code Quality Standards**

The repository enforces these standards automatically:

- **TFLint**: Terraform best practices and AWS-specific rules
- **Trivy**: Security vulnerability scanning
- **terraform-docs**: Automatic documentation generation
- **Formatting**: Consistent 2-space indentation for Terraform files
- **Validation**: Comprehensive variable validation and preconditions

#### 🔧 **Manual Commands**

For developers preferring command-line workflow:

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Run linting
tflint --recursive

# Security scan
trivy fs --config .trivy.yaml .

# Generate documentation
terraform-docs markdown table --output-file README.md .
```

## Template Structure

```
terraform-module-aws-<service>/
├── .cursorrules                    # Development guidelines and best practices
├── .editorconfig                   # Cross-editor formatting consistency
├── .gitignore                      # Standard Terraform gitignore
├── .terraform-docs.yml             # Documentation generation config
├── .tflint.hcl                     # Terraform linting configuration
├── .trivy.yaml                     # Security scanning configuration
├── .trivyignore                    # Security exceptions (customize as needed)
├── .vscode/                        # VS Code/Cursor IDE configuration
│   ├── settings.json               # Terraform-optimized settings
│   ├── extensions.json             # Recommended extensions
│   └── tasks.json                  # Pre-configured development tasks
├── .cursor/                        # Cursor-specific workspace settings
├── .github/workflows/              # CI/CD automation
│   ├── branch_validation.yml       # Quality checks and testing
│   ├── pull_request.yml            # PR automation and formatting
│   └── tag_and_release.yml         # Semantic versioning and releases
├── providers.tf                    # Terraform and provider requirements
├── main.tf                         # Main module resources (customize this)
├── variables.tf                    # Input variables (customize this)
├── outputs.tf                      # Output values (customize this)
├── examples/                       # Usage examples (add your examples)
│   ├── 00-basic/                   # Basic usage example
│   └── 10-advanced/                # Advanced configuration example
├── submodules/                     # Optional submodules (if needed)
│   └── example-submodule/          # Example submodule structure
└── README.md                       # Auto-generated documentation
```

## Customization Checklist

- [ ] Replace example resources in `main.tf` with your AWS service resources
- [ ] Update `variables.tf` with service-specific input variables
- [ ] Update `outputs.tf` with relevant resource attributes
- [ ] Modify this README header to describe your module's purpose
- [ ] Create meaningful examples in `examples/` directories
- [ ] Update `.trivyignore` with any necessary security exceptions
- [ ] Configure AWS OIDC authentication (if using CI/CD with AWS)
- [ ] Test the module with `terraform plan` and `terraform apply`
- [ ] Run `terraform-docs` to generate final documentation

## Module Development Best Practices

This template follows AWS and Terraform best practices:

### 🏗️ **Resource Management**

- Use consistent naming conventions with prefixes
- Apply comprehensive tagging to all resources
- Enable encryption by default where applicable
- Follow least privilege principles for IAM

### 📝 **Code Quality**

- Include validation blocks for all constrained variables
- Use descriptive variable and output names
- Document complex logic with inline comments
- Export all resource attributes consumers might need

### 🧪 **Testing & Validation**

- Create realistic examples that can be deployed
- Include both basic and advanced usage scenarios
- Validate examples with `terraform plan` in CI/CD
- Test edge cases and error conditions

### 🔒 **Security**

- Scan for misconfigurations with Trivy
- Review and document security exceptions
- Follow AWS security best practices
- Enable logging and monitoring where applicable

## Template Maintenance

This template is based on the patterns from `tf-module-aws-vpc` and includes:

- **Terraform**: >=1.8.0 with AWS Provider ~>6.0
- **Module Architecture**: Hierarchical with optional submodules
- **Documentation**: terraform-docs with auto-generation
- **Testing**: Example configurations with validation
- **Security**: Trivy scanning with configurable ignore rules
- **Versioning**: Semantic versioning with GitHub Actions automation

## Support

For questions about this template or AWS Terraform module development:

1. Review the [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
2. Check the [Terraform Module Development Guide](https://developer.hashicorp.com/terraform/language/modules/develop)
3. See example implementations in existing AWS modules

---

**Template Version**: 1.0.0
**Last Updated**: 2024
**Based on**: tf-module-aws-vpc patterns and best practices

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 1.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |
## Resources

| Name | Type |
|------|------|
| [aws_eks_pod_identity_association.eso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_openid_connect_provider.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.eso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.eso_secrets_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.cluster_secret_store_ps](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.cluster_secret_store_sm](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.eso](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.eso](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [null_resource.validate_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_eso](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_affinity"></a> [affinity](#input\_affinity) | Affinity settings for ESO pods. | `any` | `{}` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for secrets access. If not specified, uses current provider region. | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster where External Secrets Operator will be deployed. | `string` | n/a | yes |
| <a name="input_controller_replicas"></a> [controller\_replicas](#input\_controller\_replicas) | Number of External Secrets Operator controller replicas. | `number` | `1` | no |
| <a name="input_create_cluster_secret_store"></a> [create\_cluster\_secret\_store](#input\_create\_cluster\_secret\_store) | Whether to create ClusterSecretStore resources for AWS integration. | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create the IAM role for ESO. Set to false to use an externally managed role. | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether to create the ESO namespace. | `bool` | `true` | no |
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider) | Whether to create the OIDC provider. Only used when use\_pod\_identity is false (IRSA mode). | `bool` | `false` | no |
| <a name="input_enable_metrics"></a> [enable\_metrics](#input\_enable\_metrics) | Whether to enable Prometheus metrics for ESO. | `bool` | `true` | no |
| <a name="input_enable_parameter_store"></a> [enable\_parameter\_store](#input\_enable\_parameter\_store) | Whether to enable AWS Systems Manager Parameter Store integration. | `bool` | `false` | no |
| <a name="input_enable_secrets_manager"></a> [enable\_secrets\_manager](#input\_enable\_secrets\_manager) | Whether to enable AWS Secrets Manager integration. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, test, stage, prod). | `string` | n/a | yes |
| <a name="input_eso_version"></a> [eso\_version](#input\_eso\_version) | Version of the External Secrets Operator Helm chart to deploy. | `string` | `"0.9.11"` | no |
| <a name="input_external_iam_role_arn"></a> [external\_iam\_role\_arn](#input\_external\_iam\_role\_arn) | ARN of an externally managed IAM role to use for ESO. Only used when create\_iam\_role is false. | `string` | `null` | no |
| <a name="input_helm_timeout"></a> [helm\_timeout](#input\_helm\_timeout) | Timeout for Helm chart installation (in seconds). | `number` | `600` | no |
| <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values) | Additional Helm values to override ESO chart defaults. | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for all resources created by this module. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for External Secrets Operator installation. | `string` | `"external-secrets"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node selector for ESO pods. | `map(string)` | `{}` | no |
| <a name="input_parameter_store_arns"></a> [parameter\_store\_arns](#input\_parameter\_store\_arns) | List of AWS Systems Manager Parameter Store ARNs that ESO can access. Use ['*'] for all parameters. | `list(string)` | `[]` | no |
| <a name="input_secrets_manager_arns"></a> [secrets\_manager\_arns](#input\_secrets\_manager\_arns) | List of AWS Secrets Manager ARNs that ESO can access. Use ['*'] for all secrets. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | Tolerations for ESO pods. | `list(any)` | `[]` | no |
| <a name="input_use_pod_identity"></a> [use\_pod\_identity](#input\_use\_pod\_identity) | Whether to use EKS Pod Identity instead of IRSA. Recommended for EC2 workloads, use false for Fargate. | `bool` | `false` | no |
| <a name="input_wait_for_rollout"></a> [wait\_for\_rollout](#input\_wait\_for\_rollout) | Whether to wait for ESO to be fully ready before completing deployment. | `bool` | `true` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authentication_mode"></a> [authentication\_mode](#output\_authentication\_mode) | The authentication mode being used (pod-identity or irsa). |
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | The current AWS account ID. |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | The AWS region where secrets will be accessed. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint of the EKS cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster where ESO is deployed. |
| <a name="output_cluster_secret_store_parameter_store"></a> [cluster\_secret\_store\_parameter\_store](#output\_cluster\_secret\_store\_parameter\_store) | Name of the ClusterSecretStore for AWS Parameter Store (if created). |
| <a name="output_cluster_secret_store_secrets_manager"></a> [cluster\_secret\_store\_secrets\_manager](#output\_cluster\_secret\_store\_secrets\_manager) | Name of the ClusterSecretStore for AWS Secrets Manager (if created). |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The Kubernetes version of the EKS cluster. |
| <a name="output_eso_iam_role_arn"></a> [eso\_iam\_role\_arn](#output\_eso\_iam\_role\_arn) | The ARN of the IAM role for ESO service account (created or external). |
| <a name="output_eso_iam_role_name"></a> [eso\_iam\_role\_name](#output\_eso\_iam\_role\_name) | The name of the IAM role for ESO service account (if created by module). |
| <a name="output_eso_version"></a> [eso\_version](#output\_eso\_version) | The version of ESO that was deployed. |
| <a name="output_features_enabled"></a> [features\_enabled](#output\_features\_enabled) | Status of optional features in the ESO deployment. |
| <a name="output_helm_release_name"></a> [helm\_release\_name](#output\_helm\_release\_name) | The name of the ESO Helm release. |
| <a name="output_helm_release_status"></a> [helm\_release\_status](#output\_helm\_release\_status) | The status of the ESO Helm release. |
| <a name="output_iam_role_created"></a> [iam\_role\_created](#output\_iam\_role\_created) | Whether the IAM role was created by this module or externally managed. |
| <a name="output_kubectl_describe_eso_command"></a> [kubectl\_describe\_eso\_command](#output\_kubectl\_describe\_eso\_command) | Command to describe the ESO deployment. |
| <a name="output_kubectl_get_pods_command"></a> [kubectl\_get\_pods\_command](#output\_kubectl\_get\_pods\_command) | Command to check ESO pod status. |
| <a name="output_kubectl_get_secret_stores_command"></a> [kubectl\_get\_secret\_stores\_command](#output\_kubectl\_get\_secret\_stores\_command) | Command to list all ClusterSecretStores. |
| <a name="output_module_configuration"></a> [module\_configuration](#output\_module\_configuration) | Summary of the ESO module configuration. |
| <a name="output_name_prefix"></a> [name\_prefix](#output\_name\_prefix) | The computed name prefix used for resource naming. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The Kubernetes namespace where ESO is deployed. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC provider (if created for IRSA). |
| <a name="output_parameter_store_arns"></a> [parameter\_store\_arns](#output\_parameter\_store\_arns) | List of Parameter Store ARNs that ESO can access. |
| <a name="output_pod_identity_association_arn"></a> [pod\_identity\_association\_arn](#output\_pod\_identity\_association\_arn) | The ARN of the Pod Identity Association (if created for Pod Identity). |
| <a name="output_quick_start_guide"></a> [quick\_start\_guide](#output\_quick\_start\_guide) | Quick start guide for using the deployed ESO instance. |
| <a name="output_resource_tags"></a> [resource\_tags](#output\_resource\_tags) | The tags applied to resources created by this module. |
| <a name="output_secrets_manager_arns"></a> [secrets\_manager\_arns](#output\_secrets\_manager\_arns) | List of Secrets Manager ARNs that ESO can access. |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | The name of the Kubernetes service account for ESO. |
<!-- END_TF_DOCS -->
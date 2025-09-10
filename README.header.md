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

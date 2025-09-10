# Example Submodule

This is an optional submodule that demonstrates how to structure complex modules with multiple components.

## Usage

```hcl
module "example_submodule" {
  source = "./submodules/example-submodule"

  name_prefix        = "my-module"
  policy_description = "Custom IAM policy for my use case"

  allowed_actions = [
    "s3:GetObject",
    "s3:PutObject"
  ]

  allowed_resources = [
    "arn:aws:s3:::my-bucket/*"
  ]

  tags = {
    Component = "security"
    Purpose   = "access-control"
  }
}
```

## When to Use Submodules

Consider using submodules when:

- Your module has distinct functional components
- Components might be reused in different contexts
- You want to organize complex modules for better maintainability
- Different components have different lifecycle requirements

## Submodule Best Practices

1. **Keep submodules focused** on a single responsibility
2. **Use clear naming** that indicates the submodule's purpose
3. **Document inputs and outputs** thoroughly
4. **Version submodules** independently if they're used across modules
5. **Test submodules** both independently and as part of the main module

## Template Note

Remove this entire `submodules/` directory if your module doesn't need submodules. Most simple modules can be implemented as a single module without subcomponents.

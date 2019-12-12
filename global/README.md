# Global Workspace

Terraform configuration for global resources (without project id):

- [main.tf](./main.tf) - VaaS folder resource
- [iam.tf](./iam.tf) - IAM configuration for Vaas Folder (roles to groups bindings)
- [backend.tf](./backend.tf) - Terraform Cloud workspace configuration
- [providers.tf](./providers.tf) - List of workspace providers

Terraform Cloud [link](https://app.terraform.io/app/clientoutlook/workspaces/global)

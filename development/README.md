# Development Workspace

Terraform configuration for resources in Development workspace:

- [backend.tf](./backend.tf) - Terraform Cloud workspace configuration
- [cloudbuild.yaml](./cloudbuild.yaml) - Cloud Build triggers
- [gke.tf](./gke.tf) - GKE clusters
- [iam.tf](./iam.tf) - IAM configuration (service accounts, roles to groups bindings)
- [kms.tf](./kms.tf) - GCP KMS key ring and keys
- [main.tf](./main.tf) - GCP Project and APIs
- [network.tf](./network.tf) - VPCs, subnets, routers, nat
- [postgres.tf](./postgres.tf) - GCP Cloud SQL instances
- [providers.tf](./providers.tf) - List of workspace providers
- [variables.tf](./variables.tf) - Workspace variables

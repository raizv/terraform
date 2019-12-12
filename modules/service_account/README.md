# Service Account

This module creates GCP service account and assigns these roles on it:

```bash
"roles/logging.logWriter",
"roles/monitoring.metricWriter",
"roles/monitoring.viewer",
"roles/stackdriver.resourceMetadata.writer",
"roles/cloudtrace.agent",
"roles/iam.workloadIdentityUser",
"roles/storage.objectViewer"
```

Example:

```ruby
module "service_account" {
    # path to the module
    source = "../modules/service_account"

    name        = "gke"
    description = "Service account for GKE cluster"
    project     = "development-7c02bb4b"

    # Additional roles to be added to the service account
    service_account_roles = [
        "roles/cloudbuild.builds.builder"
    ]
}
```

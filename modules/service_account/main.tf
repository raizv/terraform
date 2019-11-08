resource "google_service_account" "sa" {
  account_id   = var.name
  display_name = var.description
  project      = var.project
}

locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_project_iam_member" "sa_roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Cloud Trace Agent
# "roles/cloudtrace.agent"
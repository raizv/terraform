# GKE service account
module "usc1a_service_account" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 2.0"
  project_id = google_project.project.project_id

  names = ["${local.usc1a_cluster.name}-cluster"]

  project_roles = [
    "${google_project.project.project_id}=>roles/logging.logWriter",
    "${google_project.project.project_id}=>roles/monitoring.metricWriter",
    "${google_project.project.project_id}=>roles/monitoring.viewer",
    "${google_project.project.project_id}=>roles/stackdriver.resourceMetadata.writer",
    "${google_project.project.project_id}=>roles/cloudtrace.agent",
    "${google_project.project.project_id}=>roles/iam.workloadIdentityUser",
    "${google_project.project.project_id}=>roles/storage.objectViewer",
  ]
}

module "external_dns_service_account" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 2.0"
  project_id = google_project.project.project_id

  names = ["external-dns"]

  project_roles = [
    "${google_project.project.project_id}=>roles/dns.admin",
  ]
}

# resource "google_project_iam_member" "external_dns_identity_user" {
#   project = google_project.project.project_id
#   role    = "roles/iam.workloadIdentityUser"
#   member  = "serviceAccount:${google_project.project.project_id}.svc.id.goog[kube-system/external-dns]"
# }

resource "google_project_iam_member" "cloudbuild_gke_deploy" {
  project = google_project.project.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"
}

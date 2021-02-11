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

module "external_dns_workload_identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "13.0.0"

  use_existing_k8s_sa = true
  name                = "external-dns"
  namespace           = "kube-system"
  project_id          = google_project.project.project_id
}

resource "google_project_iam_member" "cloudbuild_gke_deploy" {
  project = google_project.project.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"
}

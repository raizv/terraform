# Create service account to use with GKE cluster
module "gke_service_account" {
  source = "../modules/service_account"

  name        = "gke-cluster"
  description = "Service account to use with GKE"
  project     = google_project.project.project_id
}

# Allow Cloud Build service account to deploy to GKE
resource "google_project_iam_member" "cloudbuild_deploy" {
  project = google_project.project.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"

  depends_on = [module.project_services]
}

# Disabled until the issue will be fixed
# ! IssueId: https://github.com/terraform-providers/terraform-provider-google/issues/4828
# Allow Cloud Build service account to decrypt KMS secrets
# resource "google_kms_key_ring_iam_member" "cloudbuild_key_ring" {
#   key_ring_id = google_kms_key_ring.key_ring.self_link
#   role        = "roles/cloudkms.cryptoKeyDecrypter"
#   member      = "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"

#   depends_on = [module.project_services]
# }

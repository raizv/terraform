# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc"
  project                 = google_project.project.project_id
  auto_create_subnetworks = "false"

  depends_on = [module.project_services]
}

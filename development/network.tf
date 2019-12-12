# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc"
  project                 = google_project.project.project_id
  auto_create_subnetworks = "false"

  depends_on = [module.project_services]
}

# Create Subnets, Router and NAT
module "network" {
  source = "../modules/network"

  project = google_project.project.project_id
  network = google_compute_network.vpc.self_link
  region  = "northamerica-northeast1"

  ip_cidr_range         = "10.1.0.0/16"
  pod_ip_cidr_range     = "10.101.0.0/16" # cluster_secondary_range_name in gke.tf
  service_ip_cidr_range = "10.201.0.0/16" # services_secondary_range_name in gke.tf
}

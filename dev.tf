# Project configuration
resource "google_project" "development" {
  name            = "development"
  project_id      = "development-${random_id.id.hex}"
  folder_id       = google_folder.folder.name
  billing_account = data.google_billing_account.account.id
}

module "development_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "3.3.0"

  project_id = google_project.development.project_id
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudtrace.googleapis.com"
  ]
  disable_services_on_destroy = false
  disable_dependent_services  = false
}

module "development_service_account" {
  source = "./modules/service_account"

  name        = "development-gke"
  description = "Development GKE service account"
  project     = google_project.development.project_id
}

# Network configuration
resource "google_compute_network" "development_vpc" {
  name                    = "vpc"
  project                 = google_project.development.project_id
  auto_create_subnetworks = "false"
}

module "development_us_west1_network" {
  source = "./modules/network"

  project = google_project.development.project_id
  network = google_compute_network.development_vpc.self_link
  region  = "us-west1"

  ip_cidr_range         = "10.1.0.0/16"
  pod_ip_cidr_range     = "10.101.0.0/16"
  service_ip_cidr_range = "10.201.0.0/16"
}

# Cluster configuration
module "development_us_west1_cluster" {
  # source           = "github.com/raizv/terraform-gke?ref=v0.0.1"
  source = "./modules/cluster"

  name                   = "development-us-west1"
  location               = "us-west1"
  network                = google_compute_network.development_vpc.self_link
  subnetwork             = module.development_us_west1_network.subnetwork.self_link
  project                = google_project.development.project_id
  organization           = var.organization_domain
  service_account        = module.development_service_account.email
  master_ipv4_cidr_block = "172.18.0.0/28"

  preemptible = true
}

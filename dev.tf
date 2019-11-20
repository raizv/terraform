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
    "cloudtrace.googleapis.com",
    "dns.googleapis.com",
    "containeranalysis.googleapis.com"
  ]
  disable_services_on_destroy = false
  disable_dependent_services  = false
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
# module "development_us_west1_cluster" {
#   # source           = "github.com/raizv/terraform-gke?ref=v0.0.1"
#   source = "./modules/cluster"

#   name                   = "development-us-west1"
#   location               = "us-west1"
#   network                = google_compute_network.development_vpc.self_link
#   subnetwork             = module.development_us_west1_network.subnetwork.self_link
#   project                = google_project.development.project_id
#   organization           = var.organization_domain
#   service_account        = module.development_service_account.email
#   master_ipv4_cidr_block = "172.18.0.0/28"

#   preemptible = true
# }

# DNS Zone
resource "google_dns_managed_zone" "dev_us_west1" {
  name        = "dev-us-west1"
  dns_name    = "dev-us-west1.raizv.ca."
  description = "Zone for dev-us-west1 cluster"
  project     = google_project.development.project_id
}

# TLS cert
# resource "google_compute_managed_ssl_certificate" "dev_us_west1" {
#   provider = "google-beta"

#   name    = "dev-us-west1"
#   project = google_project.development.project_id
#   managed {
#     domains = ["dev-us-west1.raizv.ca."]
#   }
# }

module "development_service_account" {
  source = "./modules/service_account"

  name        = "gke-cluster"
  description = "Development GKE service account"
  project     = google_project.development.project_id
}

# Add dns.admin role to external-dns service account
module "external_dns_service_account" {
  source = "./modules/service_account"

  name                  = "external-dns"
  description           = "Service Account for External DNS service running in GKE"
  project               = google_project.development.project_id
  service_account_roles = ["roles/dns.admin"]
}

# Allow service account in GKE to use Workload Identity
resource "google_project_iam_member" "external_dns_identity_user_role" {
  project = google_project.development.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_project.development.project_id}.svc.id.goog[kube-system/external-dns]"
}

# Allow Cloud Build to deploy to GKE
resource "google_project_iam_member" "cloudbuild_deploy" {
  project = google_project.development.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_project.development.number}@cloudbuild.gserviceaccount.com"
}

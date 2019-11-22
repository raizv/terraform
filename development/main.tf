resource "random_id" "id" {
  byte_length = 4
}

data "google_organization" "org" {
  domain = var.org_domain
}

data "google_billing_account" "account" {
  display_name = "My Billing Account"
  open         = true
}

# Project configuration
resource "google_project" "project" {
  name       = "development"
  project_id = "development-${random_id.id.hex}"
  org_id     = var.org_id
  # org_id is hardcoded because data.google_organization.org.id 
  # returns "name" attribute instead of "id"
  # org_id     = data.google_organization.org.id
  billing_account = data.google_billing_account.account.id
}

# Activate project APIs
module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "3.3.0"

  project_id = google_project.project.project_id
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudtrace.googleapis.com",
    "containeranalysis.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
  disable_services_on_destroy = false
  disable_dependent_services  = false
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc"
  project                 = google_project.project.project_id
  auto_create_subnetworks = "false"
}

# Create Subnets, Router and NAT
module "us_west1_network" {
  source = "../modules/network"

  project = google_project.project.project_id
  network = google_compute_network.vpc.self_link
  region  = "us-west1"

  ip_cidr_range         = "10.1.0.0/16"
  pod_ip_cidr_range     = "10.101.0.0/16"
  service_ip_cidr_range = "10.201.0.0/16"
}

# Create service account to use with GKE cluster
module "gke_service_account" {
  source = "../modules/service_account"

  name        = "gke-cluster"
  description = "Service account to use with GKE"
  project     = google_project.project.project_id
}

# Allow Cloud Build to deploy to GKE
resource "google_project_iam_member" "cloudbuild_deploy" {
  project = google_project.project.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Cluster configuration
# module "us_west1_cluster" {
#   # source           = "github.com/raizv/terraform-gke?ref=v0.0.1"
#   source = "./modules/cluster"

#   name                   = "development-us-west1"
#   location               = "us-west1"
#   network                = google_compute_network.vpc.self_link
#   subnetwork             = module.development_us_west1_network.subnetwork.self_link
#   project                = google_project.project.project_id
#   organization           = var.organization_domain
#   service_account        = module.development_service_account.email
#   master_ipv4_cidr_block = "172.18.0.0/28"

#   preemptible = true
# }

# DNS Zone
# resource "google_dns_managed_zone" "dev_us_west1" {
#   name        = "dev-us-west1"
#   dns_name    = "dev-us-west1.raizv.ca."
#   description = "Zone for dev-us-west1 cluster"
#   project     = google_project.project.project_id
# }

# TLS cert
# resource "google_compute_managed_ssl_certificate" "dev_us_west1" {
#   provider = "google-beta"

#   name    = "dev-us-west1"
#   project = google_project.project.project_id
#   managed {
#     domains = ["dev-us-west1.raizv.ca."]
#   }
# }

# # Add dns.admin role to external-dns service account
# module "external_dns_service_account" {
#   source = "./modules/service_account"

#   name                  = "external-dns"
#   description           = "Service Account for External DNS service running in GKE"
#   project               = google_project.project.project_id
#   service_account_roles = ["roles/dns.admin"]
# }

# # Allow service account in GKE to use Workload Identity
# resource "google_project_iam_member" "external_dns_identity_user_role" {
#   project = google_project.project.project_id
#   role    = "roles/iam.workloadIdentityUser"
#   member  = "serviceAccount:${google_project.project.project_id}.svc.id.goog[kube-system/external-dns]"
# }

module "postgres" {
  # https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/2.0.0/submodules/postgresql
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "2.0.0"

  name             = "postgres"
  database_version = "POSTGRES_9_6"
  region           = "us-west1"
  project_id       = google_project.project.project_id
  zone             = "a"

  availability_type              = "ZONAL" # "REGIONAL"
  read_replica_availability_type = "ZONAL" # "REGIONAL"

  tier = "db-f1-micro"

  db_name   = "default"
  user_name = "default"
  # password for the default user. If not set, a random one will be generated and 
  # available in the generated_user_password output variable.
  # user_password = "default"

  ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = false
    private_network = google_compute_network.vpc.self_link
    authorized_networks = [{
      name  = "gke"
      value = module.development_us_west1_network.subnetwork.ip_cidr_range
    }]
  }

  read_replica_size = 0
  read_replica_tier = "db-f1-micro"

  read_replica_ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = false
    private_network = google_compute_network.vpc.self_link
    authorized_networks = [{
      name  = "gke"
      value = module.development_us_west1_network.subnetwork.ip_cidr_range
    }]
  }
}

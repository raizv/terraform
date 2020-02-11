module "network_us_central1" {
  source = "../modules/network"

  region = "us-central1"

  ip_cidr_range         = "10.1.0.0/16"
  pod_ip_cidr_range     = "10.4.0.0/14"  # Pod address range
  service_ip_cidr_range = "10.70.0.0/20" # Service address range

  project = google_project.project.project_id
  network = google_compute_network.vpc.self_link
}

# module "gke_cluster" {
#   source = "../modules/gke_cluster"

#   name                       = "development"
#   location                   = "us-central1-a"
#   master_ipv4_cidr_block     = "172.18.0.0/28"
#   release_channel            = "REGULAR"
#   enable_pod_security_policy = false
#   enable_network_policy      = false
#   disable_network_policy     = true

#   # TODO: add psp_enabled = false

#   project                       = google_project.project.project_id
#   network                       = google_compute_network.vpc.self_link
#   subnetwork                    = module.network_us_central1.subnetwork.self_link
#   cluster_secondary_range_name  = module.network_us_central1.subnetwork.secondary_ip_range.0.range_name
#   services_secondary_range_name = module.network_us_central1.subnetwork.secondary_ip_range.1.range_name
#   org_domain                    = var.org_domain
# }

resource "google_container_cluster" "primary" {
  provider   = google-beta
  name       = "primary"
  location   = "us-central1-a"
  project    = google_project.project.project_id
  network    = google_compute_network.vpc.self_link
  subnetwork = module.network_us_central1.subnetwork.self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  workload_identity_config {
    identity_namespace = "${google_project.project.project_id}.svc.id.goog"
  }

  # Private cluster configuration
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.20.0.0/28"
  }

  # VPC-native cluster configuration
  ip_allocation_policy {
    cluster_secondary_range_name  = module.network_us_central1.subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = module.network_us_central1.subnetwork.secondary_ip_range.1.range_name
  }
}

module "gke_node_pool" {
  source = "../modules/gke_node_pool"

  # cluster        = module.gke_cluster.name
  cluster        = google_container_cluster.primary.name
  location       = "us-central1-a"
  machine_type   = "e2-standard-2"
  min_node_count = 1
  max_node_count = 3
  preemptible    = true

  project         = google_project.project.project_id
  service_account = module.gke_service_account.email
}

# GKE Cluster configuration
module "gke_cluster" {
  source = "../modules/gke_cluster"

  name                   = "development"
  location               = "us-central1-a"
  master_ipv4_cidr_block = "172.18.0.0/28"

  project                       = google_project.project.project_id
  network                       = google_compute_network.vpc.self_link
  subnetwork                    = module.network_us_central1.subnetwork.self_link
  cluster_secondary_range_name  = module.network_us_central1.subnetwork.secondary_ip_range.0.range_name
  services_secondary_range_name = module.network_us_central1.subnetwork.secondary_ip_range.1.range_name
  org_domain                    = var.org_domain
}

# GKE Node Pool configuration
module "gke_node_pool" {
  source = "../modules/gke_node_pool"

  cluster         = module.gke_cluster.name
  location        = "us-central1-a"
  machine_type    = "e2-standard-2"
  min_node_count  = 1
  max_node_count  = 3
  preemptible     = true
  release_channel = "REGULAR"

  project         = google_project.project.project_id
  service_account = module.gke_service_account.email
}

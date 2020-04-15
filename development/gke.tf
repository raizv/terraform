locals {
  usc1a_cluster = {
    name                   = "usc1a"
    region                 = "us-central1"
    zone                   = "us-central1-a"
    master_ipv4_cidr_block = module.master_ranges.network_cidr_blocks["usc1a"]
  }
}

module "usc1a_network" {
  source = "../modules/network"

  name   = local.usc1a_cluster.name
  region = local.usc1a_cluster.region

  ip_cidr_range         = module.network_ranges.network_cidr_blocks["${local.usc1a_cluster.name}"]
  pod_ip_cidr_range     = module.network_ranges.network_cidr_blocks["${local.usc1a_cluster.name}-pods"]
  service_ip_cidr_range = module.network_ranges.network_cidr_blocks["${local.usc1a_cluster.name}-services"]

  project = google_project.project.project_id
  network = google_compute_network.vpc.self_link
}


# module "usc1a_gke_cluster" {
#   source = "../modules/gke_cluster"

#   name                   = local.usc1a_cluster.name
#   location               = local.usc1a_cluster.zone
#   master_ipv4_cidr_block = local.usc1a_cluster.master_ipv4_cidr_block

#   network                       = google_compute_network.vpc.self_link
#   subnetwork                    = module.usc1a_network.subnetwork.self_link
#   cluster_secondary_range_name  = module.usc1a_network.subnetwork.secondary_ip_range.0.range_name
#   services_secondary_range_name = module.usc1a_network.subnetwork.secondary_ip_range.1.range_name

#   org_domain = var.org_domain
#   project    = google_project.project.project_id
# }

# module "usc1a_gke_node_pool" {
#   source = "../modules/gke_node_pool"

#   cluster        = local.usc1a_cluster.name
#   location       = local.usc1a_cluster.zone
#   machine_type   = "n1-standard-4"
#   min_node_count = 1
#   max_node_count = 10
#   preemptible    = true

#   project         = google_project.project.project_id
#   service_account = module.usc1a_service_account.email
# }

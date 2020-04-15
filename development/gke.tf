# module "network_us_central1" {
#   source = "../modules/network"

#   region = "us-central1"

#   ip_cidr_range         = "10.0.1.0/24"
#   pod_ip_cidr_range     = "172.20.0.0/16"
#   service_ip_cidr_range = "10.96.0.0/12"

#   project = google_project.project.project_id
#   network = google_compute_network.vpc.self_link
# }

# module "gke_cluster" {
#   source = "../modules/gke_cluster"

#   name     = "development"
#   location = "us-central1-a"
#   psp      = false

#   org_domain                    = var.org_domain
#   project                       = google_project.project.project_id
#   network                       = google_compute_network.vpc.self_link
#   subnetwork                    = module.network_us_central1.subnetwork.self_link
#   cluster_secondary_range_name  = module.network_us_central1.subnetwork.secondary_ip_range.0.range_name
#   services_secondary_range_name = module.network_us_central1.subnetwork.secondary_ip_range.1.range_name
# }

# module "gke_node_pool" {
#   source = "../modules/gke_node_pool"

#   cluster        = module.gke_cluster.name
#   location       = "us-central1-a"
#   machine_type   = "e2-standard-2"
#   min_node_count = 1
#   max_node_count = 3
#   preemptible    = true

#   project         = google_project.project.project_id
#   service_account = module.gke_service_account.email
# }

# module "gke_cluster_new" {
#   source = "../modules/gke_cluster"

#   name     = "development-new"
#   location = "us-central1-a"
#   psp      = false

#   org_domain                    = var.org_domain
#   project                       = google_project.project.project_id
#   network                       = google_compute_network.vpc.self_link
#   subnetwork                    = module.network_us_central1.subnetwork.self_link
#   cluster_secondary_range_name  = module.network_us_central1.subnetwork.secondary_ip_range.0.range_name
#   services_secondary_range_name = module.network_us_central1.subnetwork.secondary_ip_range.1.range_name
# }

# module "gke_node_pool_new" {
#   source = "../modules/gke_node_pool"

#   cluster        = module.gke_cluster_new.name
#   location       = "us-central1-a"
#   machine_type   = "e2-standard-2"
#   min_node_count = 1
#   max_node_count = 3
#   preemptible    = true

#   project         = google_project.project.project_id
#   service_account = module.gke_service_account.email
# }

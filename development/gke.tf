# # GKE Cluster configuration
# module "gke" {
#   source = "../modules/gke"

#   name                   = "development"
#   location               = "northamerica-northeast1"
#   preemptible            = true
#   master_ipv4_cidr_block = "172.18.0.0/28"
#   machine_type           = "n2-standard-2"
#   min_node_count         = 1
#   max_node_count         = 3

#   project                       = google_project.project.project_id
#   network                       = google_compute_network.vpc.self_link
#   subnetwork                    = module.network.subnetwork.self_link
#   cluster_secondary_range_name  = module.network.subnetwork.secondary_ip_range.0.range_name
#   services_secondary_range_name = module.network.subnetwork.secondary_ip_range.1.range_name
#   service_account               = module.gke_service_account.email
#   org_domain                    = var.org_domain
# }

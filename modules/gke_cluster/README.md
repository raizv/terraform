# GKE

This module creates GKE cluster.

Example:

```ruby
module "gke_cluster" {
  source = "../modules/gke_cluster"

  name                   = "development"
  location               = "northamerica-northeast1"
  master_ipv4_cidr_block = "172.18.0.0/28"

  project                       = google_project.project.project_id
  network                       = google_compute_network.vpc.self_link
  subnetwork                    = module.network.subnetwork.self_link
  cluster_secondary_range_name  = module.network.subnetwork.secondary_ip_range.0.range_name
  services_secondary_range_name = module.network.subnetwork.secondary_ip_range.1.range_name
  org_domain                    = var.org_domain
}
```

# GKE

This module creates GKE cluster and NodePool.

Example:

```ruby
module "gke_node_pool" {
  source = "../modules/gke_node_pool"

  cluster         = module.gke_cluster.name
  location        = "northamerica-northeast1"
  machine_type    = "n1-standard-4"
  min_node_count  = 1
  max_node_count  = 3
  preemptible     = true
  project         = google_project.project.project_id
  service_account = module.gke_service_account.email
}

```

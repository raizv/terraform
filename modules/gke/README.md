# GKE

This module creates GKE cluster and NodePool.

Example:

```ruby
module "gke" {
    # path to the module
    source = "../modules/gke"

    name                   = "development"
    location               = "northamerica-northeast1"
    preemptible            = true
    master_ipv4_cidr_block = "172.18.0.0/28"
    machine_type           = "n2-standard-4"
    min_node_count         = 1
    max_node_count         = 3

    project         = "development-7c02bb4b"
    network         = "vpc"
    subnetwork      = "default"
    service_account = "gke-cluster@development-7c02bb4b.iam.gserviceaccount.com"
    org_domain      = "clientoutlook.com"
}
```

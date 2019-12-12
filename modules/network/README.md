# Network

This module creates subnets, router and NAT resources in GCP project.

Example:

```ruby
module "network" {
    # path to the module
    source = "../modules/network"

    project = "development-7c02bb4b"
    network = "vpc"
    region  = "northamerica-northeast1"

    ip_cidr_range         = "10.1.0.0/16"
    pod_ip_cidr_range     = "10.101.0.0/16"
    service_ip_cidr_range = "10.201.0.0/16"
}
```

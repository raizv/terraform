resource "google_compute_network" "vpc" {
  name                    = "vpc"
  project                 = google_project.project.project_id
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

module "network_ranges" {
  source  = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name     = local.usc1a_cluster.name
      new_bits = 8
    },
    {
      name     = "${local.usc1a_cluster.name}-pods"
      new_bits = 6
    },
    {
      name     = "${local.usc1a_cluster.name}-services"
      new_bits = 12
    }
  ]
}

module "master_ranges" {
  source  = "hashicorp/subnets/cidr"
  version = "~> 1.0"

  base_cidr_block = "172.18.0.0/16"
  networks = [
    {
      name     = "usc1a"
      new_bits = 12
    }
  ]
}

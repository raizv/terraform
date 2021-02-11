locals {
  usc1a_cluster = {
    name                   = "usc1a"
    region                 = "us-central1"
    zone                   = "us-central1-a"
    master_ipv4_cidr_block = module.master_ranges.network_cidr_blocks["usc1a"]
  }
}

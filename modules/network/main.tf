resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.subnetwork_name
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = var.network
  project                  = var.project
  private_ip_google_access = true

  # you cannot use master, node, Pod, or Service IP range that overlaps with 172.17.0.0/16
  secondary_ip_range {
    range_name    = "pod-secondary"
    ip_cidr_range = var.pod_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = "service-secondary"
    ip_cidr_range = var.service_ip_cidr_range
  }
}

resource "google_compute_router" "router" {
  count = var.deploy_router ? 1 : 0

  name    = var.router_name
  region  = var.region
  network = var.network
  project = var.project
}

resource "google_compute_router_nat" "nat" {
  count = var.deploy_nat ? 1 : 0

  name    = var.nat_name
  router  = google_compute_router.router.name
  region  = var.region
  project = var.project

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

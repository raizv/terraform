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

resource "google_container_cluster" "usc1a" {
  provider   = google-beta
  name       = local.usc1a_cluster.name
  location   = local.usc1a_cluster.zone
  network    = google_compute_network.vpc.self_link
  subnetwork = module.usc1a_network.subnetwork.self_link
  project    = google_project.project.project_id

  # Create the smallest possible default node pool and immediately delete it
  remove_default_node_pool = true
  initial_node_count       = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Private cluster configuration
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = local.usc1a_cluster.master_ipv4_cidr_block
  }

  # VPC-native cluster configuration
  ip_allocation_policy {
    cluster_secondary_range_name  = module.usc1a_network.subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = module.usc1a_network.subnetwork.secondary_ip_range.1.range_name
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    # enable set up HTTP L7 load balancers for services
    http_load_balancing {
      disabled = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }

  release_channel {
    channel = "STABLE"
  }

  # Allow to grant RBAC roles to the members of G Suite group
  # https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite
  authenticator_groups_config {
    # Group name must be in format gke-security-groups@org_domain.com.
    security_group = "gke-security-groups@${var.org_domain}"
  }

  # https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies
  # https://kubernetes.io/docs/concepts/policy/pod-security-policy/
  pod_security_policy_config {
    enabled = false
  }

  # Allow to link GCP Service Account to Kubernetes Service Account
  # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
  workload_identity_config {
    identity_namespace = "${google_project.project.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "usc1a" {
  provider = google-beta
  project  = google_project.project.project_id
  location = local.usc1a_cluster.zone
  cluster  = google_container_cluster.usc1a.name

  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-4"

    # Disk type and size
    disk_type    = "pd-standard"
    disk_size_gb = 100

    # auth scopes for default service account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    service_account = module.usc1a_service_account.email

    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

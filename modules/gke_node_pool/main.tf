resource "google_container_node_pool" "pool" {
  provider = google-beta
  project  = var.project
  location = var.location
  cluster  = var.cluster

  # Initial number of nodes in a node pool
  initial_node_count = var.initial_node_count

  # Enable Autoscaling
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  # Enable auto repair and auto upgrade
  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  # Surge upgrade behavior
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  # Node configuration
  node_config {
    # use preemtible VMs
    preemptible = var.preemptible

    # Node type
    machine_type = var.machine_type

    # Disk type and size
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb

    # Service account to be used by Node VMs. If not specified, "default" service account is used
    service_account = var.service_account

    # auth scopes for default service account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    # Enables workload identity on the node
    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }

  # Create new node pool before destroy old one
  lifecycle {
    create_before_destroy = true
  }
}

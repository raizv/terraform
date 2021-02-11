resource "google_container_cluster" "cluster" {
  provider   = google-beta
  name       = var.name
  location   = var.location
  network    = var.network
  subnetwork = var.subnetwork
  project    = var.project

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
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # VPC-native cluster configuration
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # Network Policy configuration
  network_policy {
    # https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent
    enabled  = false
    provider = "CALICO"
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  addons_config {
    # enable HPA
    horizontal_pod_autoscaling {
      disabled = false
    }
    # enable set up HTTP L7 load balancers for services
    http_load_balancing {
      disabled = false
    }

    # enable network policy
    network_policy_config {
      disabled = true
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }

  # https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
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
    enabled = true
  }

  # Allow to link GCP Service Account to Kubernetes Service Account
  # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
  workload_identity_config {
    identity_namespace = "${var.project}.svc.id.goog"
  }
}

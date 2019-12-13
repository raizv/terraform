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
    # In GKE this also enables the ip masquerade agent
    # https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent
    enabled  = true
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
      disabled = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
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

resource "google_container_node_pool" "pool" {
  provider = google-beta
  project  = var.project
  location = var.location
  cluster  = google_container_cluster.cluster.name

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

    # gcloud iam service-accounts add-iam-policy-binding 
    #   --role roles/iam.workloadIdentityUser 
    #   --member "serviceAccount:development-bb649fa0.svc.id.goog[greetings/default]"
    #    development-gke@development-bb649fa0.iam.gserviceaccount.com

    # kubectl annotate serviceaccount --namespace NAMESPACE 
    # default iam.gke.io/gcp-service-account=development-gke@development-bb649fa0.iam.gserviceaccount.com

    # Enables workload identity on the node
    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
    workload_metadata_config {
      node_metadata = "UNSPECIFIED"
    }
  }
}

# Setup kube system components - RBAC, PSP and etc
# resource "null_resource" "setup_kube_system" {
#   provisioner "local-exec" {
#     command = "${path.module}/setup.sh ${google_container_cluster.cluster.name} ${var.project} ${var.location}"
#   }
#   depends_on = ["google_container_cluster.cluster"]
# }

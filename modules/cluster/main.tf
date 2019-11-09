data "google_compute_subnetwork" "subnetwork" {
  self_link = var.subnetwork
}

resource "google_container_cluster" "cluster" {
  provider   = "google-beta"
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
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # VPC-native cluster configuration
  ip_allocation_policy {
    use_ip_aliases                = true
    cluster_secondary_range_name  = data.google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = data.google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name
  }

  # Configuration options for the NetworkPolicy feature.
  network_policy {
    # Whether network policy is enabled on the cluster. Defaults to false.
    # In GKE this also enables the ip masquerade agent https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent
    enabled = true

    # The selected network policy provider. Defaults to PROVIDER_UNSPECIFIED.
    provider = "CALICO"
  }

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  addons_config {
    # enable HPA
    horizontal_pod_autoscaling {
      disabled = false
    }
    # disable set up HTTP L7 load balancers for services
    http_load_balancing {
      disabled = false
    }
    # enable network policy
    network_policy_config {
      disabled = false
    }
    # istio_config {} ?
    # cloudrun_config {} ?
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  # beta https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
  release_channel {
    channel = "STABLE"
  }

  # beta https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite
  # allows you to grant RBAC roles to the members of a G Suite Google Group
  authenticator_groups_config {
    # The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. 
    # Group name must be in format gke-security-groups@yourdomain.com.
    security_group = "gke-security-groups@${var.organization}"
  }

  # beta https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies
  # https://kubernetes.io/docs/concepts/policy/pod-security-policy/
  pod_security_policy_config {
    enabled = true
  }

  # workload_identity_config {
  #   identity_namespace = "${var.project}.svc.id.goog"
  # }

  # Restrict access to the master
  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block = "x.x.x.x/x"
  #     display_name = "Office Network"
  #   }
  # }

  # beta # configuration of etcd encryption.
  # database_encryption {
  #   # ENCRYPTED # Secrets in etcd are encrypted.
  #   # DECRYPTED # Secrets in etcd are stored in plain text (at etcd level)
  #   state = "ENCRYPTED" 
  #   # Name of CloudKMS key to use for the encryption of secrets in etcd. 
  #   # Ex. projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key
  #   key_name = ""
  # }

  # beta https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering
  # to enable GKE usage metering, you first create a BigQuery dataset
  # resource_usage_export_config {
  #   enable_network_egress_metering = false
  #   bigquery_destination {
  #     dataset_id = "${var.cluster_name}_cluster_resource_usage"
  #   }
  # }

  # provisioner "local-exec" {
  #   command = "gcloud container clusters get-credentials ${self.name} --region ${self.location} --project ${self.project}"
  # }
}

resource "google_container_node_pool" "pool" {
  provider = "google-beta"
  project  = var.project
  location = var.location
  cluster  = google_container_cluster.cluster.name

  initial_node_count = var.initial_node_count
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }
  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    disk_size_gb = 100
    disk_type = "pd-standard" # or 'pd-ssd'

    # Service account to be used by Node VMs. If not specified, "default" service account is used
    service_account = var.service_account

    # gcloud iam service-accounts add-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:development-bb649fa0.svc.id.goog[greetings/default]" development-gke@development-bb649fa0.iam.gserviceaccount.com
    # kubectl annotate serviceaccount --namespace greetings default iam.gke.io/gcp-service-account=development-gke@development-bb649fa0.iam.gserviceaccount.com
    # workload_metadata_config {
    #   node_metadata = "GKE_METADATA_SERVER"
    # }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    # labels = {
    #   label_key = "label_value"
    # }

    # tags = ["http-server", "https-server"]
  }
}

# Setup kube system components - RBAC, PSP and etc
resource "null_resource" "setup_kube_system" {
  provisioner "local-exec" {
    command = "${path.module}/setup.sh ${google_container_cluster.cluster.name} ${var.project} ${var.location}"
  }
  depends_on = ["google_container_cluster.cluster"]
}
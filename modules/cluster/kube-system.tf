provider "kubernetes" {
  load_config_file = false
  host                   = "${data.template_file.gke_host_endpoint.rendered}"
  token                  = "${data.template_file.access_token.rendered}"
  cluster_ca_certificate = "${data.template_file.cluster_ca_certificate.rendered}"
}

# Setup kube system components - RBAC, PSP and etc
resource "null_resource" "setup_kube_system" {
  provisioner "local-exec" {
    command = "${path.module}/setup.sh ${google_container_cluster.cluster.name} ${var.project} ${var.location}"
  }
  depends_on = ["google_container_node_pool.pool"]
}

# Create Cluster Role Bindings
resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "cluster-admin-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "gke-admin@${var.organization}"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "edit" {
  metadata {
    name = "edit-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "edit"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "gke-edit@${var.organization}"
    api_group = "rbac.authorization.k8s.io"
  }
}

# We use this data provider to expose an access token for communicating with the GKE cluster.
data "google_client_config" "client" {}

data "template_file" "gke_host_endpoint" {
  template = "${google_container_cluster.cluster.endpoint}"
}

data "template_file" "access_token" {
  template = "${data.google_client_config.client.access_token}"
}

data "template_file" "cluster_ca_certificate" {
  template = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
}
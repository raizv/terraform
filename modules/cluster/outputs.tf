output "cluster_private_endpoint" {
  value = google_container_cluster.cluster.private_cluster_config.0.private_endpoint
}

output "cluster_public_endpoint" {
  value = google_container_cluster.cluster.private_cluster_config.0.public_endpoint
}

# output "name" {
#   # This may seem redundant with the `name` input, but it serves an important
#   # purpose. Terraform won't establish a dependency graph without this to interpolate on.
#   description = "The name of the cluster master. This output is used for interpolation with node pools, other modules."
#   value = google_container_cluster.cluster.name
# }

# The following outputs allow authentication and connectivity to the GKE Cluster.
# output "client_certificate" {
#   description = "Public certificate used by clients to authenticate to the cluster endpoint."
#   value       = base64decode(google_container_cluster.cluster.master_auth[0].client_certificate)
# }

# output "client_key" {
#   description = "Private key used by clients to authenticate to the cluster endpoint."
#   value       = base64decode(google_container_cluster.cluster.master_auth[0].client_key)
# }

# output "cluster_ca_certificate" {
#   description = "The public certificate that is the root of trust for the cluster."
#   value       = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
# }
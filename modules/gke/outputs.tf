output "cluster_private_endpoint" {
  value = google_container_cluster.cluster.private_cluster_config.0.private_endpoint
}

output "cluster_public_endpoint" {
  value = google_container_cluster.cluster.private_cluster_config.0.public_endpoint
}

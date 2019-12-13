# Disabled until the issue will be fixed
# ! IssueId: https://github.com/terraform-providers/terraform-provider-google/issues/4828

# # Create default KMS key ring
# resource "google_kms_key_ring" "key_ring" {
#   name     = "default"
#   location = "global"  
#   project = google_project.project.project_id

#   depends_on = [module.project_services]
# }

# # Create default KMS crypto key
# resource "google_kms_crypto_key" "crypto_key" {
#   name     = "default"
#   key_ring = google_kms_key_ring.key_ring.self_link

#   lifecycle {
#     prevent_destroy = true
#   }
# }

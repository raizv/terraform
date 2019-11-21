# terraform {
#   backend "gcs" {
#     bucket      = "raizv-tf-state"
#     credentials = "creds/admin.json"
#     prefix      = "admin"
#   }
# }

# resource "google_storage_bucket" "tf_state" {
#   name     = "${var.organization_name}-tf-state"
#   location = "US"
#   project  = "admin-256917"
#   versioning {
#     enabled = true
#   }
# }

terraform {
  backend "remote" {
    organization = "raizv"

    workspaces {
      name = "development"
    }
  }
}

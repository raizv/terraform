terraform {
  backend "gcs" {
    bucket      = "raizv-tf-state"
    credentials = "creds/admin.json"
    prefix      = "admin"
    #  encryption_key = ""
  }
}

resource "google_storage_bucket" "tf_state" {
  name     = "${var.organization_name}-tf-state"
  location = "US"
  project  = "admin-256917"
  versioning {
    enabled = true
  }
  # encryption {
  #   default_kms_key_name = ""
  # }
}
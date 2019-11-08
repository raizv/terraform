provider "google" {
  version     = "~> 2.17.0"
  credentials = file("creds/admin.json")
  project     = "admin-256917"
}

provider "google-beta" {
  credentials = file("creds/admin.json")
  project     = "admin-256917"
}

resource "random_id" "id" {
  byte_length = 4
  # prefix      = "${var.project_name}-"
}

data "google_organization" "domain" {
  domain = var.organization_domain
}

data "google_billing_account" "account" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_folder" "folder" {
  display_name = var.folder_name
  parent       = data.google_organization.domain.name
}

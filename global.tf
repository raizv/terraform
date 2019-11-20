resource "random_id" "id" {
  byte_length = 4
}

data "google_organization" "organization" {
  domain = var.organization_domain
}

data "google_billing_account" "account" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_folder" "folder" {
  display_name = "Folder"
  parent       = data.google_organization.organization.name
}

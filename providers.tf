provider "google" {
  version     = "~> 2.17.0"
  credentials = file("creds/admin.json")
  project     = "admin-256917"
}

provider "google-beta" {
  credentials = file("creds/admin.json")
  project     = "admin-256917"
}

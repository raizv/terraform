# Read remote state from the global workspace
data "terraform_remote_state" "global" {
  backend = "remote"

  config = {
    organization = "raizv"
    workspaces = {
      name = "global"
    }
  }
}

# Generate random number to use in the project name
resource "random_id" "project_suffix" {
  byte_length = 4
}

# Create project
resource "google_project" "project" {
  name                = var.environment
  project_id          = "${var.environment}-${random_id.project_suffix.hex}"
  folder_id           = data.terraform_remote_state.global.outputs.vaas_folder_id
  billing_account     = var.billing_account_id
  auto_create_network = false
}

# Activate project APIs
module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "6.0.0"

  project_id = google_project.project.project_id
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudtrace.googleapis.com",
    "containeranalysis.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudkms.googleapis.com"
  ]
  disable_services_on_destroy = false
  disable_dependent_services  = false
}

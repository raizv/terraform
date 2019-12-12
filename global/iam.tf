# Manage IAM roles for VaaS folder
module "vaas_iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  mode    = "additive"
  folders = [google_folder.vaas.name]

  bindings = {
    "roles/owner" = [
      "group:vaas-owner@${var.org_domain}",
    ]

    "roles/editor" = [
      "group:vaas-editor@${var.org_domain}",
    ]

    "roles/viewer" = [
      "group:vaas-viewer@${var.org_domain}",
    ]
  }
}

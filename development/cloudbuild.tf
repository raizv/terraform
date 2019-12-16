# Example of using BitBucket with Cloud Build
# resource "google_cloudbuild_trigger" "repo_name" {

#   name        = "repo_name"
#   description = "Cloud Build configuration to build repo_name service"
#   project     = google_project.project.project_id
#   disabled    = false
#   filename    = "cloudbuild.yaml"

#   trigger_template {
#     branch_name = "feature/vaas"
#     repo_name   = "https://${var.bitbucket_user}:${bitbucket_password}@bitbucket.org/${org_name}/${repo_name}.git"

#     # for public repositories
#     # repo_name   = "bitbucket_orgName_repoName"
#   }
# }

resource "google_folder" "vaas" {
  display_name = "vaas"
  parent       = "organizations/${var.org_id}"
}

output "vaas_folder_id" {
  value = google_folder.vaas.name
}

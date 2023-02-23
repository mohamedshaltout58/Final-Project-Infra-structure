#ServiceAccount 
resource "google_service_account" "project-serviceaccount" {
  account_id   = var.serviceaccount-id
  display_name = var.display-name-id
}

resource "google_project_iam_member" "cluster-admin" {
  project = var.project
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.project-serviceaccount.email}"
}

resource "google_project_iam_member" "storage-role" {
  project = var.project
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.project-serviceaccount.email}"
}

resource "google_project_iam_member" "storage-role-admin" {
  project = var.project
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.project-serviceaccount.email}"
}

resource "google_service_account_key" "instance-sa-key" {
  service_account_id = google_service_account.project-serviceaccount.id
}
resource "local_file" "my_key_file" {
  filename = "/home/mohamed/Finale-project/my-key.json"
  content  = jsonencode(google_service_account_key.instance-sa-key)
}
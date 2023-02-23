resource "google_compute_instance" "private-vm" {
  name         = var.vm-name
  machine_type = var.machine-type
  zone         = var.zone

  tags = ["management-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  metadata_startup_script = file("script.sh")
  network_interface {
    network = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.management-subnet.id
   
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.project-serviceaccount.email
    scopes = ["cloud-platform"]
  }
}
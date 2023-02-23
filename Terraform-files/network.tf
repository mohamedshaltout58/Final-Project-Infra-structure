#Create vpc
resource "google_compute_network" "vpc" {
  name                    = var.vpc-name
  auto_create_subnetworks = false
}

#Create 2 subnets
resource "google_compute_subnetwork" "management-subnet" {
  name = var.management-subnet-name
  ip_cidr_range = var.management-subnet-cidr
  region = var.region
  network = google_compute_network.vpc.self_link
}

resource "google_compute_subnetwork" "restricted-subnet" {
  name = var.restricted-subnet-name
  ip_cidr_range = var.restricted-subnet-cidr
  region = var.region
  network = google_compute_network.vpc.self_link
}
#router and NAT gatway
resource "google_compute_router" "vpc-router" {
  name    = var.router-name
  network = google_compute_network.vpc.self_link
  region = google_compute_subnetwork.management-subnet.region
}

resource "google_compute_router_nat" "vpc-nat" {
  name                               = var.nat-name
  router                             = google_compute_router.vpc-router.name
  region                             = google_compute_router.vpc-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
}

#firewall for private vm in managment subnet
resource "google_compute_firewall" "management-subnet-firewall" {
  name    = var.management-subnet-firewall
  network = google_compute_network.vpc.id
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["management-vm"]
  priority = 100
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}




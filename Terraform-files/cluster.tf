resource "google_container_cluster" "private-cluster" {
  name     = var.cluster-name 
  location = var.zone
  network = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.restricted-subnet.self_link

  remove_default_node_pool = true
  initial_node_count       = 1
  master_authorized_networks_config {
    cidr_blocks {
        cidr_block = var.management-subnet-cidr
        display_name = var.management-subnet-name
    }
  }



  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
  ip_allocation_policy {
  }


}



resource "google_container_node_pool" "private-cluster-node-pool" {
  name       = var.node-name
  location   = var.zone
  cluster    = google_container_cluster.private-cluster.name
  node_count = 1
 
  node_config {
    preemptible  = true
    machine_type = var.machine-type
    image_type   = "COS_CONTAINERD"
    service_account = google_service_account.project-serviceaccount.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"

    ]
  }
}
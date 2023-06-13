resource "google_container_cluster" "this" {
    name        = var.GKE_CLUSTER_NAME
    location    = var.GOOGlE_REGION

    remove_default_node_pool    = true
    initial_node_count          = 1
}

resource "google_container_node_pool" "this" {
  name       = var.GKE_POOL_NAME
  project    = google_container_cluster.this.project
  cluster    = google_container_cluster.this.name
  location   = google_container_cluster.this.location
  node_count = var.GKE_NUM_NODES

  node_config {
    machine_type = var.GKE_MACHINE_TYPE
  }
}

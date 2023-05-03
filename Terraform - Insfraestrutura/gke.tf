# Número de nodes para o cluster
variable "gke_num_nodes" {
  default = 1 #será criado 1 node em cada zona, totalizando 3 nodes
}

# Região que quero usar
variable "region" {
    default = "us-east1"
}

# Cluster GKE
resource "google_container_cluster" "lais-clustergke-ref" {
  name     = "lais-clustergke-df"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.lais-vpc-ref.name
  subnetwork = google_compute_subnetwork.lais-subpub-ref.name


}

# Node Pool Gerenciado Separadamente
resource "google_container_node_pool" "lais-nodes-ref" {
  name       = "lais-node-pool-df"
  location   = var.region
  cluster    = google_container_cluster.lais-clustergke-ref.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = "e2-standard-2"
    tags         = ["gke-node"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
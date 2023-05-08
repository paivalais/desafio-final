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
  location = var.region # Qual vai ser a localização do meu cluster, no caso a mesma definida na variável "region"

  remove_default_node_pool = true #O GCP disponibiliza um pool padrão. Esse comando remover esse pool para utilizar os que eu estou criando
  initial_node_count = 1 

  #networking
  network    = google_compute_network.lais-vpc-ref.name
  subnetwork = google_compute_subnetwork.lais-subpri-ref.name

  
}

# Node Pool Gerenciado Separadamente
resource "google_container_node_pool" "lais-nodes-ref" {
  name       = "lais-node-pool-df"
  location   = var.region
  cluster    = google_container_cluster.lais-clustergke-ref.name #definindo qual cluster vou fazer o deploy dos meus nodes
  node_count = var.gke_num_nodes

  autoscaling {
    min_node_count = 1 #mínimo de máquinas que pode ter no cluster
    max_node_count = 3 #máximo de máquinas que pode ter no cluster
  }

  upgrade_settings{
    max_surge = 2 #o máximo disponível para upgrade
    max_unavailable = 1 #o mínimo de máquinas indisponíveis. No caso 1, para nunca ficar down.
  }

  node_config {

    #PESQUISAR SOBRE
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ] 

    #configuração das máquinas
    machine_type = "e2-medium"
    disk_size_gb = 10
    tags         = ["gke-node"]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

}

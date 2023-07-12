provider "google" {
project = "ces-igniteprogram"
region  = "us-east1" 
}

locals {
  network_name = "lais-clustergke-ref"
  subnet_name  = "lais-subpri-ref"
  cluster_master_ip_cidr_range   = "10.0.1.0/28"
  cluster_pods_ip_cidr_range     = "10.100.0.0/16"
  cluster_services_ip_cidr_range = "10.101.0.0/16"
}













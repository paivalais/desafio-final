<h2>Implementação da Infraestrutura</h2>

A implementação da infraestrutura compõe os seguintes recursos: 
<br></br>
☁️ <b>VPC</b>
  ```terraform
  resource "google_compute_network" "lais-vpc-ref" { 
	name = "lais-vpc-df" 
	provider = google
	auto_create_subnetworks = false
  }
   ```
- Subnet privada
  
    ```terraform
  resource "google_compute_subnetwork" "lais-subpri-ref" {
	name = "lais-subpri-df"
	ip_cidr_range = "10.0.5.0/24"
	region = "us-east1"
	network = google_compute_network.lais-vpc-ref.id
	
	#Cria o range de IP secundário para os pods e services
	secondary_ip_range {
		range_name = "secondary-range-ip-services"
		ip_cidr_range = "10.100.0.0/16"
	  }

	secondary_ip_range {
		range_name = "secondary-range-ip-pods"
		ip_cidr_range = "10.101.0.0/16"
	  }
  }
     ```


- Subenet pública
  ```terraform
  resource "google_compute_subnetwork" "lais-subpub-ref" {

	name = "lais-subpub-df"
	ip_cidr_range = "10.0.4.0/24"
	region = "us-east1"
	network = google_compute_network.lais-vpc-ref.id
  }

     ```
    
- Router
  ```terraform
  resource "google_compute_router" "lais-router-ref" {
	name = "lais-router-df"
	network = google_compute_network.lais-vpc-ref.id
	bgp {
		asn = 64514
		advertise_mode = "CUSTOM"
	  }
  }
  ```
- NAT
  ```terraform
  resource "google_compute_router_nat" "nat" {
	name = "lais-nat-terraform"
	router = google_compute_router.lais-router-ref.name
	region = google_compute_router.lais-router-ref.region
	nat_ip_allocate_option = "AUTO_ONLY"
	source_subnetwork_ip_ranges_to_nat ="LIST_OF_SUBNETWORKS"
	
	subnetwork  {
		name = "lais-subpri-df"
		source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
	  }
    depends_on = [
		google_compute_subnetwork.lais-subpri-ref
    ]
  }
  ```
  
- Firewall
  ```terraform
  #regra de firewall privado
  resource "google_compute_firewall" "lais-fwlpri-ref" {
  name = "lais-fwlpri-df"
  network = "lais-vpc-df"

  allow {
    protocol = "tcp"
    ports    = ["22", "3306"] //especificar ip (boas práticas)
  }
  
  allow{
      protocol = "icmp"
  }
  source_ranges = [ "10.0.4.0/24" ] #IP da subnet pública
  target_tags = ["private-fwl"] //tag para adicionar na máquina privada

  depends_on = [
    google_compute_network.lais-vpc-ref
  ]
  }

  #regra de firewall público
  resource "google_compute_firewall" "lais-fwlpub-ref" {
    name = "lais-fwlpub-df"
    network = "lais-vpc-df"

    allow{
        protocol = "tcp" 
        ports = ["80", "22"] 
    }
    allow{
      protocol = "icmp"
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["public-fwl"]

    depends_on = [
      google_compute_network.lais-vpc-ref
    ]

  }


  ```

- GKE
  ```terraform
  module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  project_id                 = "ces-igniteprogram"
  name                       = "lais-clustergke-df"
  region                     = "us-east1"
  zones                      = ["us-east1-b", "us-east1-c", "us-east1-d"]
  network                    = "lais-vpc-df"
  subnetwork                 = "lais-subpri-df"
  ip_range_pods              = "secondary-range-ip-pods"
  ip_range_services          = "secondary-range-ip-services"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.1.0/28"
  istio                      = false
  cloudrun                   = false
  dns_cache                  = false
  remove_default_node_pool   = true
  depends_on = [google_compute_router_nat.nat]

  node_pools = [
    {
      name                      = "lais-node-pool-df"
      machine_type              = "n1-standard-2"
      node_locations            = "us-east1-b,us-east1-c"
      min_count                 = 1
      max_count                 = 11
      local_ssd_count           = 0
      spot                      = false
      local_ssd_ephemeral_count = 0
      disk_size_gb              = 30
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "sa-ignite-terraform-lais@ces-igniteprogram.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 3
      },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    }
  }
  ```

Além disso, contém um arquivo de configuração nomeado “main.tf”, que consiste em informar qual é o provedor utilizado, em qual projeto a infraestrutura será implementada, a região, e os ranges de IP do master, pods e services; e o arquivo "tfstate-bucket.tf", cuja função é armazenar o estado do Terraform (tfstate).

- main.tf
  ```terraform
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
	
  ```
- tfstate-bucket.tf
```terraform
terraform {
 backend "gcs" {
   bucket  = "lais-tfstate-df"
   prefix  = "terraform/state"
 }
}

```

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

Além disso, contém um arquivo de configuração nomeado [“main”](), que consiste em informar qual é o provedor utilizado, em qual projeto a infraestrutura será implementada, a região, e os ranges de IP do master, pods e services.

# Criando subnet privada
resource "google_compute_subnetwork" "lais-subpri-ref" { # lais-subpri-ref é o nome para referenciar a subnet privada em outro código
	name = "lais-subpri-df"
	ip_cidr_range = "10.0.5.0/24"
	region = "us-east1"
	network = google_compute_network.lais-vpc-ref.id # adicionei a referência da vpc
	
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


# Criando subnet pública
resource "google_compute_subnetwork" "lais-subpub-ref" {

	name = "lais-subpub-df"
	ip_cidr_range = "10.0.4.0/24"
	region = "us-east1"
	network = google_compute_network.lais-vpc-ref.id
    
}


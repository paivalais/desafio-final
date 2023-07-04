# Criando router
resource "google_compute_router" "lais-router-ref" {
	name = "lais-router-df"
	network = google_compute_network.lais-vpc-ref.id
	bgp {
		asn = 64514
		advertise_mode = "CUSTOM"
	}
}

# Criando NAT
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
resource "google_compute_network" "lais-vpc-ref" { # lais-vpc-ref é o nome para referenciar a VPC em outro código
	name = "lais-vpc-df" # df = desafio final
	provider = google
	auto_create_subnetworks = false
}


resource "google_compute_network" "lais-vpc-ref1" { # lais-vpc-ref é o nome para referenciar a VPC em outro código
	name = "lais-vpc-df1" # df = desafio final
	provider = google
	auto_create_subnetworks = false
}


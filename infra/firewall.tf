# Criando o firewall privado
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

# Criando regra de firewall público
resource "google_compute_firewall" "lais-fwlpub-ref" {
    name = "lais-fwlpub-df"
    network = "lais-vpc-df"

    allow{
        protocol = "tcp" 
        ports = ["80", "22"] //especificar ip (boas práticas)
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


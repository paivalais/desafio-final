# Criando regra de firewall público
resource "google_compute_firewall" "lais-firewallpub-ref" {
    name = "lais-firewallpub-df"
    network = "lais-vpc-df"

    allow{
        protocol = "tcp" 
        ports = ["80", "22"] # especificar ip (boas práticas)
    }
    
    allow{
      protocol = "icmp"
  }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["public-fwl"]

}

# Criando regra de firewall privado
resource "google_compute_firewall" "lais-firewallpri-ref" {
  name = "lais-firewallpri-df"
  network = "lais-vpc-df"

  allow {
    protocol = "tcp"
    ports    = ["22", "3306"] # especificar ip (boas práticas)
  }
  
  allow{
      protocol = "icmp"
  }

  target_tags = ["private-fwl"] # tag para adicionar na máquina privada
}
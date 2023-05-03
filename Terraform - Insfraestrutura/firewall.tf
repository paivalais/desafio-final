# Criando o firewall
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

}

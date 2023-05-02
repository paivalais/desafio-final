# Manter o IP da máquina pública estático

resource "google_compute_address" "lais-ipstatic-ref" {
    name = "lais-ipv4address-df"
    region = "us-east1"
}

# Criando máquina pública
resource "google_compute_instance" "lais-vmpub-ref" {
	name = "lais-vmpub-df"
	machine_type = "e2-micro"
	zone = "us-east1-b"

    tags = ["public-fwl"]

	boot_disk {
		initialize_params {
		image = "ubuntu-os-cloud/ubuntu-1804-lts"
		labels = {my_label = "value"}
		}
	}

  network_interface {
    network = google_compute_network.lais-vpc-ref.id
    subnetwork = google_compute_subnetwork.lais-subpub-ref.id  
    access_config { # mantém o ip público estático
        nat_ip = google_compute_address.lais-ipstatic-ref.address
    }
  }

      metadata = {
        "ssh-keys" = <<EOT
        lais_paiva:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1v1XBBD84yAQughUj1LVZCs8ktrl6QcnpqfL1pLENGh472ETRhxoYoaLA0SDoA8RVwlJFK8wrP2Qty2ewcuRNhcXdne2jibFJWL4GCj3X0s5CsftgTSkInC76z0+QrFluWdWYAgiK/xM72f3aUbyoDPeLHrT1C2MhsE4m+oW2mzHRGodqHaBlfC3f+6kZ9218GQOqKSdi0ftsHucyjo9kle4gHDM1LJEQR0g8Y+o3DK9283yo7aWXXtaBXj768zMmsCv8P2uzGMz1RFwAt/lzKRfjrKKKMs8ub4vBjWFOYGCSpwLd95KPkW4pOhRj9vebi1xcL1+KfFGBhyAVZ9CRgdc3QoRNZsNHSoXQqj+ILw6OoZRrecQ/ZcB1vqWebpmDAxxbfiGz1plqkCcM999D8LEhOJapnOxFKrpGg0nrxipcmSQmQRDqQl5sPaePLs8VVbXH7ZoObKxgmQbZcqIvcU4NeUKQ7BVBvWJGxpYQ1FQwF4CcB64WkWmgz9qKEoDL50Wmw4rJBMHxJWr5FhGMABtpKIqn3F1U4eiKootNV9wQ1lzRl99RfW236s2Zj3ZlmhpH5Ek4MOAEh9jflJz/VmJGgYNWHjWqzlZdgeLUIOHSDccGtsXdrGFeu8sZu8kaLL7RIjitmX1ZIcp1ZXehOHfwxgcX3hSGRponothmeQ== lais_paiva@lais-terraform-tools
        EOT
  }
}


#  Criando máquina pública - tools
resource "google_compute_instance" "lais-vmtools-ref" {
	name = "lais-vmtools-df"
	machine_type = "e2-micro"
	zone = "us-east1-b"

    tags = ["public-fwl"]

	boot_disk {
		initialize_params {
		image = "ubuntu-os-cloud/ubuntu-1804-lts"
		labels = {my_label = "value"}
		}
	}


  network_interface {
    network = google_compute_network.lais-vpc-ref.id
    subnetwork = google_compute_subnetwork.lais-subpub-ref.id  
    access_config{}
  }
    metadata = {
        "ssh-keys" = <<EOT
        lais_paiva:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP4d1XMXC0VEQxX1O3YU4I/iYhchcQ70+mFpiKGoU1B4hyhczHmdI3AiJ2exCVdOlaOLrPkVPqYQi3lWIzUfETZnOwu2fgpAQq08QEwh9zOK5AEpnc4q6uUXJ4pBjR99lWO6WzIrHzfml4W0dlbZpJvffZ9WnTC0VXqHc9uDuuv/aPXi59QZq1qwv2dUNZ0STy+ceDx8SQmg0OIerSKs44BTQSM9Yjfqp3Tu/7VheIQ8Ng6cIhvcE6R/aziCuJnR5DiNPjHgFUXsTQXE3WGNFUeg3ayXs/QNUGRpS1TUEZd/fdZoNEG67Tpi946NT797BGF05XHuKsu93riKcdB2yCmn0+/5fw6vpNhXe0mndfkKIV9D4r6QerloJU8ZNwPF5ToZ0mIjwlXYXoaEPuqrr430e9SXo8BCnpJ/IjPjOT3pFEyXlbuzDEtUOHwnu4ZjokbjOtq/aJC3HIkeQ7PDn5iuw7jYS4y4HPuEUWmcATRamSv6am9Npehl1eH1/wvivu+socZ7xeYVPfJJhocXZBKow+gyW0lncJ90LlfJQUrj4iwKgfpGSY2wkzaT9KwuiphpgimFrhajYkL6qCAv6hW0tDjZwYGR57fgjUL/vNyUW5/yWP3uRZJjyTP32SJOO6j42Tvt2L1smJJz09kSyqh+0oPxTJ8L27BEgKbF2Z/Q== lais_paiva@lais-vmpub-terraform
        lais_paiva:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1v1XBBD84yAQughUj1LVZCs8ktrl6QcnpqfL1pLENGh472ETRhxoYoaLA0SDoA8RVwlJFK8wrP2Qty2ewcuRNhcXdne2jibFJWL4GCj3X0s5CsftgTSkInC76z0+QrFluWdWYAgiK/xM72f3aUbyoDPeLHrT1C2MhsE4m+oW2mzHRGodqHaBlfC3f+6kZ9218GQOqKSdi0ftsHucyjo9kle4gHDM1LJEQR0g8Y+o3DK9283yo7aWXXtaBXj768zMmsCv8P2uzGMz1RFwAt/lzKRfjrKKKMs8ub4vBjWFOYGCSpwLd95KPkW4pOhRj9vebi1xcL1+KfFGBhyAVZ9CRgdc3QoRNZsNHSoXQqj+ILw6OoZRrecQ/ZcB1vqWebpmDAxxbfiGz1plqkCcM999D8LEhOJapnOxFKrpGg0nrxipcmSQmQRDqQl5sPaePLs8VVbXH7ZoObKxgmQbZcqIvcU4NeUKQ7BVBvWJGxpYQ1FQwF4CcB64WkWmgz9qKEoDL50Wmw4rJBMHxJWr5FhGMABtpKIqn3F1U4eiKootNV9wQ1lzRl99RfW236s2Zj3ZlmhpH5Ek4MOAEh9jflJz/VmJGgYNWHjWqzlZdgeLUIOHSDccGtsXdrGFeu8sZu8kaLL7RIjitmX1ZIcp1ZXehOHfwxgcX3hSGRponothmeQ== lais_paiva@lais-terraform-tools
        EOT
  }
  
}



// Criando máquina privada
resource "google_compute_instance" "lais-vmpri-ref" {
	name = "lais-vmpri-df"
	machine_type = "e2-micro"
	zone = "us-east1-b"

    tags = ["private-fwl"]

	boot_disk {
		initialize_params {
		image = "ubuntu-os-cloud/ubuntu-1804-lts"
		labels = {my_label = "value"}
		}
	}

    metadata = {
        "ssh-keys" = <<EOT
        lais_paiva:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP4d1XMXC0VEQxX1O3YU4I/iYhchcQ70+mFpiKGoU1B4hyhczHmdI3AiJ2exCVdOlaOLrPkVPqYQi3lWIzUfETZnOwu2fgpAQq08QEwh9zOK5AEpnc4q6uUXJ4pBjR99lWO6WzIrHzfml4W0dlbZpJvffZ9WnTC0VXqHc9uDuuv/aPXi59QZq1qwv2dUNZ0STy+ceDx8SQmg0OIerSKs44BTQSM9Yjfqp3Tu/7VheIQ8Ng6cIhvcE6R/aziCuJnR5DiNPjHgFUXsTQXE3WGNFUeg3ayXs/QNUGRpS1TUEZd/fdZoNEG67Tpi946NT797BGF05XHuKsu93riKcdB2yCmn0+/5fw6vpNhXe0mndfkKIV9D4r6QerloJU8ZNwPF5ToZ0mIjwlXYXoaEPuqrr430e9SXo8BCnpJ/IjPjOT3pFEyXlbuzDEtUOHwnu4ZjokbjOtq/aJC3HIkeQ7PDn5iuw7jYS4y4HPuEUWmcATRamSv6am9Npehl1eH1/wvivu+socZ7xeYVPfJJhocXZBKow+gyW0lncJ90LlfJQUrj4iwKgfpGSY2wkzaT9KwuiphpgimFrhajYkL6qCAv6hW0tDjZwYGR57fgjUL/vNyUW5/yWP3uRZJjyTP32SJOO6j42Tvt2L1smJJz09kSyqh+0oPxTJ8L27BEgKbF2Z/Q== lais_paiva@lais-vmpub-terraform
        lais_paiva:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1v1XBBD84yAQughUj1LVZCs8ktrl6QcnpqfL1pLENGh472ETRhxoYoaLA0SDoA8RVwlJFK8wrP2Qty2ewcuRNhcXdne2jibFJWL4GCj3X0s5CsftgTSkInC76z0+QrFluWdWYAgiK/xM72f3aUbyoDPeLHrT1C2MhsE4m+oW2mzHRGodqHaBlfC3f+6kZ9218GQOqKSdi0ftsHucyjo9kle4gHDM1LJEQR0g8Y+o3DK9283yo7aWXXtaBXj768zMmsCv8P2uzGMz1RFwAt/lzKRfjrKKKMs8ub4vBjWFOYGCSpwLd95KPkW4pOhRj9vebi1xcL1+KfFGBhyAVZ9CRgdc3QoRNZsNHSoXQqj+ILw6OoZRrecQ/ZcB1vqWebpmDAxxbfiGz1plqkCcM999D8LEhOJapnOxFKrpGg0nrxipcmSQmQRDqQl5sPaePLs8VVbXH7ZoObKxgmQbZcqIvcU4NeUKQ7BVBvWJGxpYQ1FQwF4CcB64WkWmgz9qKEoDL50Wmw4rJBMHxJWr5FhGMABtpKIqn3F1U4eiKootNV9wQ1lzRl99RfW236s2Zj3ZlmhpH5Ek4MOAEh9jflJz/VmJGgYNWHjWqzlZdgeLUIOHSDccGtsXdrGFeu8sZu8kaLL7RIjitmX1ZIcp1ZXehOHfwxgcX3hSGRponothmeQ== lais_paiva@lais-terraform-tools
        EOT
  }

    network_interface {
        network = google_compute_network.lais-vpc-ref.id
        subnetwork = google_compute_subnetwork.lais-subpri-ref.id  
    }
}
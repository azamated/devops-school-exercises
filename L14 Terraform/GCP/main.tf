provider "google" {
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "vm_instance" {
  name         = "ubuntu-builder"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
    }
  }

   allow {
    protocol = "all"
  }

  source_tags = ["web"]
  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}
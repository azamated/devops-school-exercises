provider "google" {
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Builder node
resource "google_compute_instance" "vm_instance" {
  name         = "ubuntu-builder"
  machine_type = "e2-micro"


  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"

  access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = [
      " apt-get update && sudo apt-get install -y docker.io maven default-jdk google-cloud-sdk",
      "cd /tmp",
      "git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git",
      "mvn package -f /tmp/boxfuse-sample-java-war-hello",
      "gsutil cp /tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war gs://aamirakulov/"
    ]
  }

    }

# Firewall rules
resource "google_compute_firewall" "default" {
  name    = "instance-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }

}









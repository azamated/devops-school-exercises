provider "google" {
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Builder node
resource "google_compute_instance" "vm_instance1" {
  name         = "ubuntu-builder4"
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

  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get install -y docker.io maven default-jdk google-cloud-sdk"

  }

  provisioner "local-exec" {
    command = "cd /tmp && git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git"

  }

  provisioner "local-exec" {
    command = "sudo mvn package -f /tmp/boxfuse-sample-java-war-hello"

  }

  provisioner "local-exec" {
    command = "sudo gsutil cp /tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war gs://aamirakulov/"

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









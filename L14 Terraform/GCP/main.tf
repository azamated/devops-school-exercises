provider "google" {
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Builder node
resource "google_compute_instance" "vm_instance1" {
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
  provisioner "local-exec" {
    command = "apt-get update && apt-get install -y docker.io && apt-get install -y maven && apt-get install -y git"
  }

  provisioner "local-exec" {
    command = "cd /tmp && git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git && mvn package -f /tmp/boxfuse-sample-java-war-hello"
  }

  provisioner "local-exec" {
    command = "docker build -f /tmp/boxfuse-sample-java-war-hello/Dockerfile -t boxfusewebapp /tmp/boxfuse-sample-java-war-hello"
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

#Copy war artifact to Google Storage bucket
resource "google_storage_bucket_object" "war-file" {
  name   = "java-webapp-prod"
  source = "/tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war"
  bucket = "aamirakulov"
}






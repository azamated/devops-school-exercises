provider "google" {
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Builder node
resource "google_compute_instance" "vm_instance1" {
  name         = "ubuntu-builder1"
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
    command = "sudo apt-get update && sudo apt-get install -y docker.io && sudo apt-get install -y maven && sudo apt-get install -y git"
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "cd /tmp && git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git && sudo mvn package -f /tmp/boxfuse-sample-java-war-hello"
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "sudo docker build -f /tmp/boxfuse-sample-java-war-hello/Dockerfile -t boxfusewebapp /tmp/boxfuse-sample-java-war-hello"
    on_failure = continue
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
  name   = "java-webapp-prod.war"
  source = "/tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war"
  bucket = "aamirakulov"
}

#################
# Production node
#################
resource "google_compute_instance" "vm_instance2" {
  name         = "ubuntu-production1"
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
    command = "sudo apt-get update && sudo apt-get install -y docker.io && sudo apt-get install -y git && sudo apt-get install -y default-jdk && sudo apt-get install -y tomcat8"
    on_failure = continue
  }

   provisioner "local-exec" {
    command = "cd /tmp && wget https://storage.googleapis.com/aamirakulov/java-webapp-prod.war && sudo cp java-webapp-prod.war /usr/local/tomcat/webapps/"
    on_failure = continue
  }

}





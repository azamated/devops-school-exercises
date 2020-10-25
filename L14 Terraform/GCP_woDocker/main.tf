provider "google" {
  credentials = "${file("credentials.json")}"
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
    # A default network is created for all GCP_woDocker projects
    network = "default"

  access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  provisioner "file" {
    source = "credentials.json"
    destination = "~/credentials.json"
  }

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
    agent = "false"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update && sudo apt-get install -y docker.io maven google-cloud-sdk",
      "cd /tmp",
      "git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git",
      "mvn package -f /tmp/boxfuse-sample-java-war-hello",
      "gcloud auth activate-service-account --key-file=~/credentials.json",
      #"gsutil cp /tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war gs://aamirakulov/",
      "docker build -f /tmp/boxfuse-sample-java-war-hello/Dockerfile -t boxfusewebapp /tmp/boxfuse-sample-java-war-hello"
    ]
  }

    }

#################
# Production node
#################
resource "google_compute_instance" "vm_instance2" {
  name         = "ubuntu-production"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
    }
  }

  network_interface {
    # A default network is created for all GCP_woDocker projects
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
      "apt-get update && apt-get install -y docker.io  default-jdk tomcat8",
      "gcloud auth activate-service-account --key-file=~/credentials.json",
      "cd /tmp && wget https://storage.googleapis.com/aamirakulov/hello-1.0.war && sudo cp java-webapp-prod.war /var/lib/tomcat8/webapps/"
    ]
  }

}

################
# Firewall rules
################
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








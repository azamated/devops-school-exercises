provider "google" {
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

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

  metadata_startup_script = "apt-get update; apt-get install -y docker.io && apt-get install -y maven && apt-get install -y git; cd /tmp && git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git && mvn package -f /tmp/boxfuse-sample-java-war-hello; docker build -f /tmp/boxfuse-sample-java-war-hello/Dockerfile -t boxfusewebapp /tmp/boxfuse-sample-java-war-hello"
  }

resource "google_storage_bucket_object" "war-file" {
  name   = "hello-1.0.war"
  source = "/tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war"
  bucket = "devops"
}

resource "google_compute_instance" "vm_instance2" {
  name         = "ubuntu-production"
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

  metadata_startup_script = "apt-get update; apt-get install -y docker.io && apt-get install tomcat8 -y && cd /usr/local/tomcat/webapps/ && wget https://storage.googleapis.com/aamirakulov/hello-1.0.war"
}


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

resource "google_compute_network" "default" {
  name = "instance-network"
}



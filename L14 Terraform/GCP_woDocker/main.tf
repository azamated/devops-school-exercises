
#Declaring GCP provider
provider "google" {
  credentials = "${file("credentials.json")}"
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Declaring instance-1
resource "google_compute_instance" "vm_instance1" {
  name         = "ubuntu-builder"
  machine_type = "e2-micro"


  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
    }
  }

  network_interface {
    # Default network
    network = "default"

  access_config {
      // Ephemeral IP
    }
  }

  #Copy public key
  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  #Copy GCP auth token
  provisioner "file" {
    source = "credentials.json"
    destination = "/tmp/credentials.json"

    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
  }
  }

  #Remote command execution over ssh
  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y docker.io",
      "apt-get install -y default-jdk maven",
      "apt-get install -y python google-cloud-sdk",
      "cd /tmp",
      "git clone https://github.com/azamated/boxfuse-sample-java-war-hello.git",
      "mvn package -f /tmp/boxfuse-sample-java-war-hello",
      "gcloud auth activate-service-account --key-file=/tmp/credentials.json",
      "gsutil cp /tmp/boxfuse-sample-java-war-hello/target/hello-1.0.war gs://aamirakulov/",
      "echo Instance-1 has been successfully deployed!"
    ]
  }
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
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

resource "google_project" "project" {
  name            = "Wild Workouts"
  project_id      = var.project
  billing_account = data.google_billing_account.account.id
}



#################
# Production node
#################
# Declaring instance-2
resource "google_compute_instance" "vm_instance2" {
  #depends_on = [google_compute_instance.vm_instance1]
  name         = "ubuntu-production"
  machine_type = "e2-micro"


  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
    }
  }

  network_interface {
    #default network
    network = "default"

  access_config {
  // Ephemeral IP
    }
  }

  #Copy public key
  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  #Copy GCP auth token
  provisioner "file" {
    source = "credentials.json"
    destination = "/tmp/credentials.json"

    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
  }
  }

  #Remote command execution over ssh
  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y docker.io",
      "apt-get install -y default-jdk",
      "apt-get install -y tomcat8",
      "gcloud auth activate-service-account --key-file=/tmp/credentials.json",
      "gsutil cp gs://aamirakulov/hello-1.0.war /var/lib/tomcat8/webapps/",
      "echo Instance-2 has been successfully deployed!",
      "sleep 5m"
    ]
  }
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
  }
}









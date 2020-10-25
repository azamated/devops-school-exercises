
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
      #"docker build -f /tmp/boxfuse-sample-java-war-hello/Dockerfile -t boxfusewebapp /tmp/boxfuse-sample-java-war-hello",
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

# NUll resource for delay 30 secs
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
}

#################
# Production node
#################
# Declaring instance-2
resource "google_compute_instance" "vm_instance2" {
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
      #"cd /tmp && wget https://storage.googleapis.com/aamirakulov/hello-1.0.war && cp hello-1.0.war /var/lib/tomcat8/webapps/",
      "echo Instance-2 has been successfully deployed!"
    ]
  }
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
  }
}









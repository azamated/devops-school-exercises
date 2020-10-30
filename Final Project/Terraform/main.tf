terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_key_pair" "id_rsa" {
  key_name   = "aws_id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8LHlRNOITkvCFipJu/GFBVICUEXEtZJBawqJyKk8frjIeSvdgpZSfOxdgRDHUQ8XWote6QxSXsp4f1JtBWJNAagKI0y14egh0mxAMtzcPkSrNR4IxjmMEFBS70tgLyg13V4FStK2rrcRPwpmttdD0/bys3FALk7yTIlGfqpEH4RN2qk+xkLR6HMwXPFEDtqt9KyIND84F8TjwxOZGahKlia5kS2W+9V3L6fn3KuSf36vIrLahvgQsYIQeBgaIKtlDlhqHUzOz/+Y1E22T08OuqswqwEQdvlfybchGc/68gYlkNib3BKGIAtbJY4h6ynPKdPcEK01AUHxj6fy6nynHABBrSJtlqcgbJfGaZxoRl0AwTWH3DuEHNgqFyDdr54eStHEfmatNdqf21VdqqegNQaw8AX0LUWCzp5sZ4NzuN25+RRoVjtFaZjWINoVimqWqRVntatW1LDNTnA05BRad1eAp37D9Js1yqT/8ilWmH/UO8EsujQvEagvspcevXI0= root@devops"
}

######################
#Create aws instances#
######################

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "builder" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = [aws_security_group.build_allow_ssh.id]
  wait_for_fulfillment = true

  #Copies aws cred file to the instance
  provisioner "file" {
    source      = "~/.aws/credentials"
    destination = "~/.aws/credentials"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
      host = [aws_instance.builder.public_ip]
    }
  }
}

resource "aws_instance" "production" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = [aws_security_group.prod_allow_ssh_web.id]
  wait_for_fulfillment = true

  #Copies aws cred file to the instance
  provisioner "file" {
    source      = "~/.aws/credentials"
    destination = "~/.aws/credentials"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
      host = [aws_instance.production.public_ip]
    }
  }
}


##############################################
#Create security groups with FW ports allowed#
##############################################

resource "aws_security_group" "build_allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH inbound traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prod_allow_ssh_web" {
  name = "allow_ssh_web"
  description = "Allow SSH and Web inbound traffic"
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############
#Provisioners#
##############
resource "aws_spot_instance_request" "app-ec2" {
    ami = "ami-1c999999"
    spot_price    = "0.008"
    instance_type = "t2.small"
    tags {
        Name = "${var.app_name}"
    }
    key_name = "mykeypair"
    associate_public_ip_address = true
    vpc_security_group_ids = ["sg-99999999"]
    subnet_id = "subnet-99999999"
    iam_instance_profile = "myInstanceRole"
    user_data = <<-EOF
#!/bin/bash
echo ECS_CLUSTER=APP-STAGING >> /etc/ecs/ecs.config
    EOF
}

resource "aws_route53_record" "staging" {
   zone_id = "XXXXXXXX"
   name = "staging.myapp.com"
   type = "A"
   ttl = "300"
   records = ["${aws_spot_instance_request.app-ec2.public_ip}"]

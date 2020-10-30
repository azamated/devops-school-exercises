terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

##############################################
#Create aws instances#
##############################################
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "builder1" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  security_groups = ["aws_security_group_build"]

}

resource "aws_instance" "production2" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  security_groups = ["aws_security_group_prod"]
}
##############################################
#Create security groups with FW ports allowed#
##############################################
resource "aws_security_group_build" "allow_ssh" {
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
}

resource "aws_security_group_prod" "allow_ssh_web" {
  name = "allow_ssh"
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
}
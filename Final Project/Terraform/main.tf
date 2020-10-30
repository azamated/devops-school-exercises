terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "ami_key_pair_name" {}
######################
#Create aws instances#
######################

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "builder3" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  vpc_security_group_ids = [aws_security_group.build_allow_ssh.id]

}

resource "aws_instance" "production3" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  vpc_security_group_ids = [aws_security_group.prod_allow_ssh_web.id]
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

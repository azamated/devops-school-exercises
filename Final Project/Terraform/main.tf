terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
######################
#Create aws instances#
######################
provider "aws" {
  region = "us-east-2"
  profile = "default"
}

#Copy a public key to instances
resource "aws_key_pair" "id_rsa" {
  key_name   = "aws_id_rsa_pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkVfqAygZmeGkgEbG1r6iLpuuMEpRr7ekvLcJ2L/T+0luMkW9I/R5+ANkGUnLHOwZpK9Dhx/F/WU9rT6sJOjyg++aLY1+AEOMWvMgpMPbv1szD0UCFPWIIWcuJuIalBBtVB2nZH5UoHGm1JGmLajv3yeIQM6B3YW4n0LuBSUE5nb/FOn4wxSh5lRAqsuRbTY3F2ARHbVBiAlCQXV7M6TIsfkDiM/LuG8ojWDJNTUCPVBRGoDgGu2Ry64k7O780lsUrk0dt8agtXZljM8MikVKHgFNC1vO8ptXtbCI/9WHJI1x/hffziZ33maeZNkbWFEetGdPM7PCdrzdF5FONv3bVuuMyBTElcJnW/hUNz1CspOKHyt41KQbL4Ws7eFn1wmAOHh3q1oH7HkZv4cM+lKvMaK2/MNgbJlwbW1EA0hobqfJd7/x8j/VKw3Nxni6PTf6STtDb86TgG8fayFft9/DKl+ToMuNW0mmwC9v/5uyl1eEo+0VdkSlOmb1d9xrFhqc= root@devops"
}

resource "aws_instance" "builder" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.build_allow_ssh.id}"]

}

resource "aws_instance" "production" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = ["${aws_security_group.prod_allow_ssh_web.id}"]


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


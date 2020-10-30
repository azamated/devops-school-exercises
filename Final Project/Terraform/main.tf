terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


#Copy a public key to instances
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
  user_data = <<EOF
#!/bin/bash
sudo mkdir ~/.aws
EOF

resource "aws_instance" "production" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"
  monitoring = true
  key_name = "aws_id_rsa_pub"
  vpc_security_group_ids = [aws_security_group.prod_allow_ssh_web.id]
  user_data = <<EOF
#!/bin/bash
sudo mkdir ~/.aws
EOF

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
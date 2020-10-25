provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "my_inst" {
  ami = "ami-07efac79022b86107"
  instance_type = "t2.micro"

}

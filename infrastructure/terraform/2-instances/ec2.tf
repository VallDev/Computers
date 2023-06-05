provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {

  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    region = "${var.region}"
    bucket = "${var.remote_state_bucket}"
    key    = "${var.remote_state_key}"
  }
}

resource "aws_security_group" "public-sg" {
  name        = "COMPUTERS-DPL-SG"
  description = "Public Security Group"
  vpc_id      = var.id_vpc_this_infra

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "key-pair" {
  key_name   = var.pair_key_name
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "ec2-jenkins" {
  ami                         = var.ubuntu_ami
  instance_type               = var.type_instance
  subnet_id                   = var.id_public_subnet_1_this_infra
  key_name                    = aws_key_pair.key-pair.key_name
  availability_zone           = "us-east-1a"
  vpc_security_group_ids      = [aws_security_group.public-sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "COMPUTERS-DPL-JENKINS-EC2"
  }

  #depends_on = ["aws_key_pair.key-pair"]
}

resource "aws_instance" "ec2-sonar" {
  ami                         = var.ubuntu_ami
  instance_type               = var.type_instance_medium
  subnet_id                   = var.id_public_subnet_2_this_infra
  key_name                    = aws_key_pair.key-pair.key_name
  availability_zone           = "us-east-1b"
  vpc_security_group_ids      = [aws_security_group.public-sg.id]
  associate_public_ip_address = true

  user_data = file("sonar-setup.sh")

  tags = {
    Name = "COMPUTERS-DPL-SONARQUBE-EC2"
  }

  #depends_on = ["aws_key_pair.key-pair"]
}

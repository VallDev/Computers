variable "region" {
  default = "us-east-1"
}

variable "remote_state_bucket" {}
variable "remote_state_key" {}

variable "id_vpc_this_infra" {
  default = "vpc-0273dcea6ae03198f"
}

variable "pair_key_name" {
  default = "COMPUTERS-DPL-key"
}

variable "ubuntu_ami" {
  default = "ami-0261755bbcb8c4a84"
}

variable "type_instance" {
  default = "t2.small"
}

variable "id_public_subnet_1_this_infra" {
  default = "subnet-0bbb05168c214e16c"
}

variable "type_instance_medium" {
  default = "t2.medium"
}

variable "id_public_subnet_2_this_infra" {
  default = "subnet-0011f7e7294435a70"
}

variable "id_private_subnet_1_this_infra" {
  default = "subnet-0ce57c5b40c20a7a6"
}

variable "id_private_subnet_2_this_infra" {
  default = "subnet-0b0703c4896147788"
}

variable "id_private_subnet_3_this_infra" {
  default = "subnet-0494ffa5ed2d9ae82"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_username" {
  description = "Username of db"
}

variable "db_password" {
  description = "Password of db"
}


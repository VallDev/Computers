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

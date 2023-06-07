variable "region" {
  default = "us-east-1"
}

variable "remote_state_bucket" {}
variable "remote_state_key" {}

variable "ecs_cluster_name" {}
variable "internet_cidr_blocks" {}

variable "id_vpc_this_infra" {
  description = "VPC ID OF MY INFRA"
}

variable "private_subnet_1_id" {}
variable "private_subnet_2_id" {}
variable "private_subnet_3_id" {}

variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}
variable "public_subnet_3_id" {}

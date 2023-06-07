variable "region" {
  default = "us-east-1"
}

variable "remote_state_key" {}
variable "remote_state_bucket" {}

#application variables for task
variable "ecs_service_name" {}
variable "docker_image_url" {}
variable "memory" {}
variable "docker_container_port" {}

variable "id_vpc_this_infra" {
  description = "VPC ID OF MY INFRA"
}

variable "internet_cidr_blocks" {}

variable "desired_task_number" {}
variable "ecs_cluster_name_this_infra" {}

variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}
variable "public_subnet_3_id" {}

variable "ecs_alb_listener_arn_this_infra" {}

variable "task_definition_name" {}
variable "docker_image_url" {}

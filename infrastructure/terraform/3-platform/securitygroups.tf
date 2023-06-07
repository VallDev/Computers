resource "aws_security_group" "ecs-alb-security-group" {
  name        = var.ecs_cluster_name
  description = "Security Group for ALB to traffic to ECS Cluster"
  vpc_id      = var.id_vpc_this_infra

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.internet_cidr_blocks}"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.internet_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.internet_cidr_blocks}"]
  }
}

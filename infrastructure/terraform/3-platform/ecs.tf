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

resource "aws_ecs_cluster" "production-fargate-cluster" {
  name = "COMPUTERS-DPL-FARGATE-CLUSTER"
}

resource "aws_alb" "ecs-cluster-alb" {
  name            = "${var.ecs_cluster_name}-ALB"
  internal        = false
  security_groups = ["${aws_security_group.ecs-alb-security-group.id}"]
  subnets         = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}", "${var.public_subnet_3_id}"]

  tags = {
    Name = "${var.ecs_cluster_name}-ALB"
  }
}

resource "aws_alb_target_group" "ecs-default-target-group" {
  name     = "${var.ecs_cluster_name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.id_vpc_this_infra

  tags = {
    Name = "${var.ecs_cluster_name}-TG"
  }
}

resource "aws_lb_listener" "ecs-alb-http-listener" {
  load_balancer_arn = aws_alb.ecs-cluster-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs-default-target-group.arn

  }

  depends_on = ["aws_alb_target_group.ecs-default-target-group"]
}

resource "aws_iam_role" "ecs-cluster-role" {
  name               = var.ecs_cluster_name
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
            },
            "Action": "sts:AssumeRole"
        }
    ]
    }
    EOF 
}

resource "aws_iam_role_policy" "ecs-cluster-policy" {
  name   = "${var.ecs_cluster_name}-IAM-POLYCY"
  role   = aws_iam_role.ecs-cluster-role.id
  policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecs:*",
                    "ec2:*",
                    "elasticloadbalancing:*",
                    "ecr:*",
                    "cloudwatch:*",
                    "s3:*",
                    "rds:*",
                    "logs:*"
                ],
                "Resource": "*"
            }
        ]
}
EOF
}

resource "aws_ecr_repository" "ecr-repo-app" {
  name                 = "computers-dpl-ecr-repo-img-andres"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

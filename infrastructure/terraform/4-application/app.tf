provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {

  }
}

data "terraform_remote_state" "platform" {
  backend = "s3"

  config = {
    key    = "${var.remote_state_key}"
    bucket = "${var.remote_state_bucket}"
    region = "${var.region}"
  }
}

data "template_file" "ecs-task-definition-template" {
  template = file("task_definition.json")

  vars = {
    task_definition_name  = "${var.ecs_service_name}"
    ecs_service_name      = "${var.ecs_service_name}"
    docker_image_url      = "${var.docker_image_url}"
    memory                = "${var.memory}"
    docker_container_port = "${var.docker_container_port}"
    region                = "${var.region}"
  }
}

resource "aws_ecs_task_definition" "app-task-definition" {
  container_definitions    = data.template_file.ecs-task-definition-template.rendered
  family                   = var.ecs_service_name
  cpu                      = 512
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.fargate-iam-role.arn
  task_role_arn            = aws_iam_role.fargate-iam-role.arn
}

resource "aws_iam_role" "fargate-iam-role" {
  name               = "${var.ecs_service_name}-IAM-ROLE"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy" "fargate-iam-role-policy" {
  name   = "${var.ecs_service_name}-IAM-ROLE-POLICY"
  role   = aws_iam_role.fargate-iam-role.id
  policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecs:*",
                    "elasticloadbalancing:*",
                    "ecr:*",
                    "cloudwatch:*",
                    "logs:*"
                ],
                "Resource": "*"
            }
        ]
}
EOF
}

resource "aws_security_group" "app-security-group" {
  name        = var.ecs_service_name
  description = "Security Group for go app to communicate in and out"
  vpc_id      = var.id_vpc_this_infra

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
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

  tags = {
    Name = "${var.ecs_service_name}-SG"
  }
}

resource "aws_alb_target_group" "ecs-app-target-group" {
  name        = "${var.ecs_service_name}-TG"
  port        = var.docker_container_port
  protocol    = "HTTP"
  vpc_id      = var.id_vpc_this_infra
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 60
    timeout             = 30
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }

  tags = {
    Name = "${var.ecs_service_name}-TG"
  }
}

resource "aws_ecs_service" "ecs-service" {
  name            = var.ecs_service_name
  task_definition = var.ecs_service_name
  desired_count   = var.desired_task_number
  cluster         = var.ecs_cluster_name_this_infra
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}", "${var.public_subnet_3_id}"]
    security_groups  = ["${aws_security_group.app-security-group.id}"]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = var.ecs_service_name
    container_port   = var.docker_container_port
    target_group_arn = aws_alb_target_group.ecs-app-target-group.arn
  }
}

resource "aws_alb_listener_rule" "ecs-alb-listener-rule" {
  listener_arn = var.ecs_alb_listener_arn_this_infra

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs-app-target-group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_cloudwatch_log_group" "go-app-log-group" {
  name = "${var.ecs_service_name}-LogGroup"
}

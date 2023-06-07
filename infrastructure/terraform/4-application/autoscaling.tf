resource "aws_iam_role" "ecs-autoscale-role" {
  name = "ecs-AUTOSCALING-application-dpl-computer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["application-autoscaling.amazonaws.com", "ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ecs-service-scaling" {

  statement {
    effect = "Allow"

    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ecs-service-scaling-policy" {
  name        = "computers-to-scaling"
  path        = "/"
  description = "Allow ecs service scaling"

  policy = data.aws_iam_policy_document.ecs-service-scaling.json


}

resource "aws_iam_role_policy_attachment" "ecs-service-scaling-policy-aws_iam_role_policy_attachment" {
  role       = aws_iam_role.ecs-autoscale-role.name
  policy_arn = aws_iam_policy.ecs-service-scaling-policy.arn

  depends_on = [aws_iam_role.ecs-autoscale-role, aws_iam_policy.ecs-service-scaling-policy]
}



resource "aws_appautoscaling_target" "autoscaling-target-app" {
  max_capacity       = 6
  min_capacity       = 3
  resource_id        = "service/${var.ecs_cluster_name_this_infra}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs-autoscale-role.arn

  depends_on = [aws_appautoscaling_target.autoscaling-target-app]
}

resource "aws_appautoscaling_policy" "policy-autoscaling" {
  name               = "Autoscaling policy in ECS"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling-target-app.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling-target-app.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling-target-app.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }

  depends_on = [aws_appautoscaling_target.autoscaling-target-app]
}

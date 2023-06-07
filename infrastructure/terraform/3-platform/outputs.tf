output "vpc_id" {
  value = var.id_vpc_this_infra
}

output "ecs_alb_listener_arn" {
  value = aws_lb_listener.ecs-alb-http-listener.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.production-fargate-cluster.name
}

output "ecs_cluster_role_name" {
  value = aws_iam_role.ecs-cluster-role.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.ecs-cluster-role.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.ecr-repo-app.repository_url
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.ecr-repo-app.arn
}

output "aws_alb_target_group_ecs_default_tg_arn" {
  value = aws_alb_target_group.ecs-default-target-group.arn
}

output "ecs_cluster_role_id" {
  value = aws_iam_role.ecs-cluster-role.id
}

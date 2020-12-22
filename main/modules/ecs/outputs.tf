output "ecs_cluster" {
  value = aws_ecs_cluster.dev_to
}

output "ecs_service_name" {
  value = aws_ecs_service.dev_to
}
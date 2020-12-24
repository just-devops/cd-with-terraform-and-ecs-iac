resource "aws_ecs_cluster" "dev_to" {
  name               = var.cluster_name
  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "dev-to"
  }
}

resource "aws_ecs_task_definition" "dev_to" {
  family                = var.cluster_name
  container_definitions = <<TASK_DEFINITION
  [
  {
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "environment": [
      {
        "name": "AUTHOR",
        "value": "Christos Paschalidis"
      }
    ],
    "cpu": 512,
    "memory": 1024,
    "essential": true,
    "image": "${var.image_latest}",
    "name": "${var.cluster_name}"
  }
]
TASK_DEFINITION

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = var.desired_task_memory
  cpu                      = var.desired_task_cpu
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn

  tags = {
    Name = "dev-to"
  }
}

resource "aws_ecs_service" "dev_to" {
  name             = var.cluster_name
  cluster          = aws_ecs_cluster.dev_to.id
  task_definition  = aws_ecs_task_definition.dev_to.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [
    desired_count]
  }

  network_configuration {
    subnets          = [var.ecs_subnet_a.id, var.ecs_subnet_b.id, var.ecs_subnet_c.id]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.ecs_target_group.arn
    container_name   = var.cluster_name
    container_port   = 80
  }
}
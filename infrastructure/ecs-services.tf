# Development Environment ECS Services

resource "aws_ecs_service" "dev_server" {
  name            = "Service-dev-server"
  cluster         = aws_ecs_cluster.dev.id
  task_definition = aws_ecs_task_definition.server.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight           = 1
    base            = 0
  }

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev_server.arn
    container_name   = "server"
    container_port   = 3000
  }
}

resource "aws_ecs_service" "dev_client" {
  name            = "Service-dev-client"
  cluster         = aws_ecs_cluster.dev.id
  task_definition = aws_ecs_task_definition.client.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight           = 1
    base            = 0
  }

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev_client.arn
    container_name   = "client"
    container_port   = 80
  }
}

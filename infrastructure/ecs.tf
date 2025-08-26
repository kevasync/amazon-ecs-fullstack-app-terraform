# ECS Cluster Configuration
resource "aws_ecs_cluster" "dev" {
  name = "cluster-dev"
}

# Development Server Service
resource "aws_ecs_service" "dev_server" {
  name            = "service-dev-server"
  cluster         = aws_ecs_cluster.dev.id
  task_definition = aws_ecs_task_definition.server.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight           = 100
    base            = 0
  }

  network_configuration {
    # ... existing network config ...
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.server.arn
    container_name   = "server"
    container_port   = 3000
  }
}

# Development Client Service
resource "aws_ecs_service" "dev_client" {
  name            = "service-dev-client"
  cluster         = aws_ecs_cluster.dev.id
  task_definition = aws_ecs_task_definition.client.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight           = 100
    base            = 0
  }

  network_configuration {
    # ... existing network config ...
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.client.arn
    container_name   = "client"
    container_port   = 80
  }
}

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

/*===================
      AWS ALB
====================*/

resource "aws_lb" "alb" {
  count              = var.create_alb ? 1 : 0
  name               = "alb-${var.name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "alb-${var.name}"
  }
}

resource "aws_lb_listener" "alb_listener" {
  count             = var.create_alb ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group
  }
}

resource "aws_lb_listener_rule" "path_based" {
  count        = length(var.path_pattern) > 0 ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }
}

resource "aws_lb_target_group" "target_group" {
  count       = var.create_target_group ? 1 : 0
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc
  target_type = var.tg_type

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 15
    matcher            = "200"
    path               = var.health_check_path
    port               = var.health_check_port
    protocol           = var.protocol
    timeout            = 10
    unhealthy_threshold = 10
  }

  tags = {
    Name = var.name
  }
}
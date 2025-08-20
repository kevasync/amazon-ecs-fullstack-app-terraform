# Consolidated Development ALB

resource "aws_lb" "dev" {
  name               = "alb-dev-consolidated"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = var.public_subnets

  tags = {
    Environment = "development"
  }
}

resource "aws_lb_listener" "dev_http" {
  load_balancer_arn = aws_lb.dev.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "dev_https" {
  load_balancer_arn = aws_lb.dev.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# Server API path-based routing
resource "aws_lb_listener_rule" "dev_server" {
  listener_arn = aws_lb_listener.dev_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_server.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# Client app path-based routing
resource "aws_lb_listener_rule" "dev_client" {
  listener_arn = aws_lb_listener.dev_https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_client.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "dev_server" {
  name        = "tg-dev-server"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_target_group" "dev_client" {
  name        = "tg-dev-client"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

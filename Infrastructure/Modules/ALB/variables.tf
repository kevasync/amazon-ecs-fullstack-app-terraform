variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}

variable "create_alb" {
  description = "Controls if the Application Load Balancer should be created"
  type        = bool
  default     = false
}

variable "create_target_group" {
  description = "Controls if the Target Group should be created"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "A list of subnets to associate with the ALB"
  type        = list(string)
  default     = []
}

variable "security_group" {
  description = "The security group of the ALB"
  type        = string
  default     = ""
}

variable "target_group" {
  description = "The target group ARN to associate with the ALB"
  type        = string
  default     = ""
}

variable "vpc" {
  description = "VPC ID to create the target group in"
  type        = string
  default     = ""
}

variable "port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "tg_type" {
  description = "Type of target group"
  type        = string
  default     = "ip"
}

variable "health_check_path" {
  description = "Path for the health check"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port for the health check"
  type        = number
  default     = 80
}

variable "path_pattern" {
  description = "Path pattern for the listener rule"
  type        = list(string)
  default     = []
}

variable "priority" {
  description = "Priority for the listener rule"
  type        = number
  default     = null
}
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "frontend_image" {
  description = "Frontend container image"
  type        = string
}

variable "backend_image" {
  description = "Backend container image"
  type        = string
}

variable "frontend_cpu" {
  description = "Frontend task CPU units"
  type        = number
}

variable "frontend_memory" {
  description = "Frontend task memory (MiB)"
  type        = number
}

variable "backend_cpu" {
  description = "Backend task CPU units"
  type        = number
}

variable "backend_memory" {
  description = "Backend task memory (MiB)"
  type        = number
}

variable "alb_target_group_arn_frontend" {
  description = "ARN of ALB target group for frontend"
  type        = string
}

variable "alb_target_group_arn_backend" {
  description = "ARN of ALB target group for backend"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of ALB"
  type        = string
}

variable "documentdb_endpoint" {
  description = "DocumentDB cluster endpoint"
  type        = string
}

variable "documentdb_password" {
  description = "DocumentDB password SSM parameter ARN"
  type        = string
} 
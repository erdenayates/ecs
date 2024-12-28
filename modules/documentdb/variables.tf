variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for DocumentDB"
  type        = list(string)
}

variable "instance_count" {
  description = "Number of DocumentDB instances"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance class for DocumentDB instances"
  type        = string
  default     = "db.t3.medium"
}

variable "master_username" {
  description = "Master username for DocumentDB cluster"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password for DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "ecs_security_group_id" {
  description = "Security group ID of the ECS tasks"
  type        = string
} 
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where DocumentDB will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for DocumentDB"
  type        = list(string)
}

variable "instance_count" {
  description = "Number of DocumentDB instances"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "Instance class for DocumentDB instances"
  type        = string
}

variable "master_username" {
  description = "Master username for DocumentDB cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "backend_security_group_id" {
  description = "Security group ID of the backend ECS service"
  type        = string
} 
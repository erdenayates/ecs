output "backend_security_group_id" {
  description = "Security group ID of the backend ECS service"
  value       = aws_security_group.backend.id
} 
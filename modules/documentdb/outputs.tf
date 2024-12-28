output "endpoint" {
  description = "The DNS address of the DocumentDB cluster"
  value       = aws_docdb_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the DocumentDB cluster"
  value       = aws_docdb_cluster.main.reader_endpoint
}

output "port" {
  description = "The port on which the DocumentDB cluster accepts connections"
  value       = aws_docdb_cluster.main.port
}

output "security_group_id" {
  description = "Security group ID of the DocumentDB cluster"
  value       = aws_security_group.docdb.id
}

output "master_username" {
  description = "Master username for the DocumentDB cluster"
  value       = aws_docdb_cluster.main.master_username
}

output "password_parameter_name" {
  description = "Name of the SSM Parameter Store parameter containing the database password"
  value       = aws_ssm_parameter.docdb_password.name
} 
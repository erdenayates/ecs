resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.environment}-docdb-cluster"
  engine                 = "docdb"
  master_username        = var.master_username
  master_password        = var.master_password
  backup_retention_period = 5
  preferred_backup_window = "03:00-04:00"
  skip_final_snapshot    = true
  
  availability_zones     = [data.aws_availability_zones.available.names[0]]
  
  db_subnet_group_name   = aws_docdb_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.docdb.id]

  storage_encrypted     = false

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-docdb-cluster"
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_docdb_cluster_instance" "main" {
  count              = var.instance_count
  identifier         = "${var.environment}-docdb-instance-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.instance_class

  availability_zone  = data.aws_availability_zones.available.names[0]

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-docdb-instance-${count.index + 1}"
  }
}

resource "aws_docdb_subnet_group" "main" {
  name       = "${var.environment}-docdb-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-docdb-subnet-group"
  }
}

resource "aws_security_group" "docdb" {
  name        = "${var.environment}-docdb-sg"
  description = "Security group for DocumentDB cluster"
  vpc_id      = var.vpc_id

  # Allow inbound MongoDB traffic from ECS tasks
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [var.backend_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-docdb-sg"
  }
}

# Store the database password in SSM Parameter Store
resource "aws_ssm_parameter" "docdb_password" {
  name        = "/${var.environment}/docdb/master_password"
  description = "Master password for DocumentDB cluster"
  type        = "SecureString"
  value       = var.master_password

  tags = {
    Environment = var.environment
  }
}

# Create a CloudWatch Log Group for DocumentDB audit logs
resource "aws_cloudwatch_log_group" "docdb_audit" {
  name              = "/aws/docdb/${var.environment}/audit"
  retention_in_days = 30

  tags = {
    Environment = var.environment
  }
} 
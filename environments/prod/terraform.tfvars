# Region configuration
aws_region = "us-west-2"
environment = "prod"

# VPC and networking
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

# Subnet configuration
private_subnet_cidrs = [
  "10.0.1.0/24",  # Private subnet in us-west-2a
  "10.0.2.0/24",  # Private subnet in us-west-2b
  "10.0.3.0/24"   # Private subnet in us-west-2c
]

public_subnet_cidrs = [
  "10.0.101.0/24", # Public subnet in us-west-2a
  "10.0.102.0/24", # Public subnet in us-west-2b
  "10.0.103.0/24"  # Public subnet in us-west-2c
]

# ECS Task Configuration
frontend_cpu    = 256
frontend_memory = 512
backend_cpu     = 512
backend_memory  = 1024

# Container Images with your AWS Account ID
frontend_image = "public.ecr.aws/h2n4d7m6/task-manager-frontend:latest"
backend_image  = "public.ecr.aws/h2n4d7m6/task-manager-backend:latest"

# DocumentDB Configuration
documentdb_instance_count = 1
documentdb_instance_class = "db.t3.medium"
documentdb_master_username = "dbadmin"
# Note: Don't store sensitive values in terraform.tfvars
# Use environment variables or AWS Secrets Manager instead
# documentdb_password = "CHANGE_ME_AND_USE_ENV_VAR" 
terraform {
  required_version = ">= 1.0.0"
  
  backend "s3" {
    bucket         = "erd-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"
  
  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
}

module "ecs" {
  source = "../../modules/ecs"
  
  environment         = var.environment
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  
  frontend_image     = var.frontend_image
  backend_image      = var.backend_image
  
  frontend_cpu       = var.frontend_cpu
  frontend_memory    = var.frontend_memory
  backend_cpu        = var.backend_cpu
  backend_memory     = var.backend_memory
  
  alb_target_group_arn_frontend = module.alb.target_group_arn_frontend
  alb_target_group_arn_backend  = module.alb.target_group_arn_backend
  
  documentdb_endpoint = module.documentdb.endpoint
  documentdb_password = var.documentdb_password
}

module "alb" {
  source = "../../modules/alb"
  
  environment        = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
}

module "documentdb" {
  source = "../../modules/documentdb"
  
  environment         = var.environment
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  password           = var.documentdb_password
} 
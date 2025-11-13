terraform {
  required_version = ">= 1.0.0"

  # Uncomment and configure to use Terraform Cloud / remote backend
  # backend "remote" {
  #   organization = "l00188348"
  #   workspaces {
  #     name = "ca3-terraform-dev"
  #   }
  # }
}

provider "aws" {
  region = "us-east-1"
}

# --- módulo VPC ---
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]

  tags = {
    Project     = "CA3-Terraform"
    Environment = "dev"
    Owner       = "Romulo"
  }
}

# --- módulo Security Groups---
module "security" {
  source           = "../../modules/security"
  vpc_id           = module.vpc.vpc_id
  vpc_cidr_block   = module.vpc.vpc_cidr_block
}

# --- módulo Webserver ---
module "webserver" {
  source = "../../modules/webserver"

  subnet_id         = module.vpc.public_subnet_ids[0]
  key_name          = var.key_name
  security_group_ids = [
    module.security.web_sg_id,
    module.security.internal_sg_id
  ]
}

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
  private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"] # Private subnets ajustment
  availability_zones = ["us-east-1a", "us-east-1b"]

  tags = {
    Project     = "CA3-Terraform"
    Environment = "dev"
    Owner       = "Romulo"
  }
}

# --- Multiple Webservers modules for high availability. ---
module "webserver_az1" {
  source = "../../modules/webserver"
  
  subnet_id          = module.vpc.public_subnet_ids[0]  # 10.0.1.0/24 (us-east-1a)
  security_group_ids = [module.security.web_sg_id, module.security.internal_sg_id]
}

module "webserver_az2" {
  source = "../../modules/webserver"
  
  subnet_id          = module.vpc.public_subnet_ids[1]  # 10.0.2.0/24 (us-east-1b)  
  security_group_ids = [module.security.web_sg_id, module.security.internal_sg_id]
}

# --- módulo Security Groups---
module "security" {
  source           = "../../modules/security"
  vpc_id           = module.vpc.vpc_id
  vpc_cidr_block   = module.vpc.vpc_cidr_block
}

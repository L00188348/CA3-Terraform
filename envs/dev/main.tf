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

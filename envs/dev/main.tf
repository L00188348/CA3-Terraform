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

# --- VPC MODULE ---
# Creates the networking foundation: VPC, subnets, route tables, NAT Gateway, and Internet Gateway
# Following the assignment requirements: CIDR 10.0.0.0/16 with public and private subnets across 2 AZs
module "vpc" {
  source = "../../modules/vpc"

  # Core networking configuration as per assignment specification
  vpc_cidr           = "10.0.0.0/16"  # Primary VPC CIDR block
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]      # Public subnets for NAT Gateway and ALB
  private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"]    # Private subnets for web servers
  availability_zones = ["us-east-1a", "us-east-1b"]        # High availability across 2 AZs

  # Resource tagging for cost management and organization
  tags = {
    Project     = "CA3-Terraform"   # Project identifier
    Environment = "dev"              # Environment classification
    Owner       = "Romulo"          # Resource owner
  }
}

# --- WEBSERVER MODULES FOR HIGH AVAILABILITY ---
# Deploys Apache web servers across two availability zones for fault tolerance
# Web servers are placed in private subnets as per assignment requirements
# Accessible only through the Application Load Balancer (security best practice)

module "webserver_az1" {
  source = "../../modules/webserver"
  
  # Placement in private subnet for security: web servers shouldn't have direct internet access
  subnet_id          = module.vpc.private_subnet_ids[0]  # Private subnet in us-east-1a (10.0.10.0/24)
  
  # Security group assignment:
  # - web_sg_id: Allows HTTP(80) and SSH(22) from ALB and administration
  # - internal_sg_id: Allows internal VPC communication between instances
  security_group_ids = [module.security.web_sg_id, module.security.internal_sg_id]
}

module "webserver_az2" {
  source = "../../modules/webserver"
  
  # Second web server in different AZ for high availability
  subnet_id          = module.vpc.private_subnet_ids[1]  # Private subnet in us-east-1b (10.0.20.0/24)
  
  # Same security configuration as AZ1 for consistency
  security_group_ids = [module.security.web_sg_id, module.security.internal_sg_id]
}

# --- SECURITY GROUPS MODULE ---
# Implements network security controls following least-privilege principle
# Creates separate security groups for web servers, ALB, and internal communication
module "security" {
  source         = "../../modules/security"
  vpc_id         = module.vpc.vpc_id           # Reference to the created VPC
  vpc_cidr_block = module.vpc.vpc_cidr_block   # VPC CIDR for internal communication rules
}

# --- APPLICATION LOAD BALANCER MODULE ---
# Distributes incoming HTTP traffic across multiple web servers
# Provides high availability, health checking, and SSL termination capability
module "alb" {
  source = "../../modules/alb"
  
  # Networking configuration
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids  # ALB placed in public subnets
  
  # Target instances for load balancing
  web_instance_ids       = [
    module.webserver_az1.instance_id,  # Web server in AZ1
    module.webserver_az2.instance_id   # Web server in AZ2
  ]
  
  # Security group allowing HTTP traffic from internet to ALB
  alb_security_group_id = module.security.alb_sg_id
}
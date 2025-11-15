# VPC Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = module.vpc.private_subnet_cidrs
}

# Security Groups Outputs
output "web_sg_id" {
  description = "ID of the web security group"
  value       = module.security.web_sg_id
}

output "internal_sg_id" {
  description = "ID of the internal security group"
  value       = module.security.internal_sg_id
}

# Web Servers Outputs - UPDATED for multiple instances
output "webserver_az1_instance_id" {
  description = "Instance ID of webserver in Availability Zone 1"
  value       = module.webserver_az1.instance_id
}

output "webserver_az1_public_ip" {
  description = "Public IP address of webserver in Availability Zone 1"
  value       = module.webserver_az1.instance_public_ip
}

output "webserver_az1_public_dns" {
  description = "Public DNS name of webserver in Availability Zone 1"
  value       = module.webserver_az1.instance_public_dns
}

output "webserver_az2_instance_id" {
  description = "Instance ID of webserver in Availability Zone 2"
  value       = module.webserver_az2.instance_id
}

output "webserver_az2_public_ip" {
  description = "Public IP address of webserver in Availability Zone 2"
  value       = module.webserver_az2.instance_public_ip
}

output "webserver_az2_public_dns" {
  description = "Public DNS name of webserver in Availability Zone 2"
  value       = module.webserver_az2.instance_public_dns
}

# Consolidated Outputs (useful for monitoring and load balancer configuration)
output "all_webserver_public_ips" {
  description = "List of all webserver public IP addresses"
  value = [
    module.webserver_az1.instance_public_ip,
    module.webserver_az2.instance_public_ip
  ]
}

output "all_webserver_instance_ids" {
  description = "List of all webserver instance IDs"
  value = [
    module.webserver_az1.instance_id,
    module.webserver_az2.instance_id
  ]
}

output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    vpc_id          = module.vpc.vpc_id
    public_subnets  = length(module.vpc.public_subnet_ids)
    private_subnets = length(module.vpc.private_subnet_ids)
    webservers      = 2
    availability_zones = ["us-east-1a", "us-east-1b"]
  }
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "Full URL to access the application via ALB"
  value       = module.alb.alb_url
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}
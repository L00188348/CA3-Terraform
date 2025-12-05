# VPC OUTPUTS
# Essential networking information for integration with other Terraform modules or manual configurations
output "vpc_id" {
  description = "ID of the created VPC (Used for referencing in other modules and security groups)"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (For resources requiring internet access: ALB, NAT Gateway)"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs (For internal resources: web servers, databases, application servers)"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway (Useful for network troubleshooting and route management)"
  value       = module.vpc.internet_gateway_id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets (For firewall rules and network planning)"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets (For internal networking and security group rules)"
  value       = module.vpc.private_subnet_cidrs
}

# SECURITY GROUPS OUTPUTS
# Security group references for attaching to other resources
output "web_sg_id" {
  description = "ID of the web server security group (Allows HTTP from ALB and SSH administration)"
  value       = module.security.web_sg_id
}

output "internal_sg_id" {
  description = "ID of the internal security group (Enables secure communication between instances within VPC)"
  value       = module.security.internal_sg_id
}

output "alb_sg_id" {
  description = "ID of the ALB security group (Allows internet HTTP traffic to reach the load balancer)"
  value       = module.security.alb_sg_id
}

# WEB SERVERS OUTPUTS
# Instance identification for management, monitoring, and automation
output "webserver_az1_instance_id" {
  description = "Instance ID of the web server in Availability Zone 1 (us-east-1a)"
  value       = module.webserver_az1.instance_id
}

output "webserver_az2_instance_id" {
  description = "Instance ID of the web server in Availability Zone 2 (us-east-1b)"
  value       = module.webserver_az2.instance_id
}

# Consolidated instance information for automation scripts and monitoring tools
output "all_webserver_instance_ids" {
  description = "List of all web server instance IDs (Useful for bulk operations, monitoring, and automation)"
  value = [
    module.webserver_az1.instance_id,
    module.webserver_az2.instance_id
  ]
}

# INFRASTRUCTURE SUMMARY OUTPUT
# High-level overview of the deployed environment for quick reference
output "deployment_summary" {
  description = "Summary of the deployed high-availability infrastructure"
  value = {
    vpc_id              = module.vpc.vpc_id
    public_subnets      = length(module.vpc.public_subnet_ids)
    private_subnets     = length(module.vpc.private_subnet_ids)
    webservers          = 2
    availability_zones  = ["us-east-1a", "us-east-1b"]
    architecture        = "Multi-AZ with private web servers and public ALB"
  }
}

# APPLICATION LOAD BALANCER OUTPUTS
# Critical outputs for accessing and managing the web application
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer (Primary endpoint for accessing the web application)"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "Full HTTP URL to access the application via the Application Load Balancer"
  value       = module.alb.alb_url
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer (Required for IAM policies, CloudWatch metrics, and integrations)"
  value       = module.alb.alb_arn
}

# NAT GATEWAY OUTPUTS
# Information about NAT Gateways for troubleshooting and cost monitoring
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs (For outbound internet access from private subnets)"
  value       = module.vpc.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  description = "List of NAT Gateway public IPs (Useful for whitelisting in external services)"
  value       = module.vpc.nat_gateway_public_ips
}
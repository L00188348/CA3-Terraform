variable "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB deployment"
  type        = list(string)
}

variable "web_instance_ids" {
  description = "List of web server instance IDs for target group"
  type        = list(string)
}
# subnet_id should be for PRIVATE subnet (web servers go in private subnets)
variable "subnet_id" {
  description = "ID of the private subnet where the web server instance will be launched"
  type        = string
}

# Optional: if you want to use a custom AMI instead of latest Amazon Linux 2
variable "ami" {
  description = "Optional custom AMI ID. If empty (default), uses latest Amazon Linux 2 AMI"
  type        = string
  default     = ""  # Empty string triggers data source lookup in main.tf
}

# Instance type with sensible default for web servers
variable "instance_type" {
  description = "EC2 instance type for web server (e.g., t3.micro, t3.small)"
  type        = string
  default     = "t3.micro"
}

# SSH key is optional if you plan to use AWS Session Manager for access
variable "key_name" {
  description = "Optional name of the EC2 key pair for SSH access. Leave empty for Session Manager only."
  type        = string
  default     = ""
}

# Security groups - should at minimum include: ALB access + SSH/internal access
variable "security_group_ids" {
  description = "List of security group IDs to attach to the web server instance"
  type        = list(string)
  default     = []  # Should be populated by parent module
}
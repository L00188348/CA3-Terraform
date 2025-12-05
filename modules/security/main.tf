# Security Group for web servers in private subnets
# These servers host Apache and are accessible only via the Application Load Balancer
# Following security best practice: web servers should not be directly exposed to the internet
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for Apache web servers in private subnets. Allows HTTP from ALB and SSH for administration."
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "web-sg" },
    var.vpc_id != "" ? { "CreatedFor" = "CA3-Terraform" } : {}
  )
}

# HTTP ingress rule - MODIFIED: Now allows traffic only from ALB, not from the internet
# This follows the principle of least privilege after moving web servers to private subnets
resource "aws_security_group_rule" "web_ingress_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id  # Only ALB can access web servers
  security_group_id        = aws_security_group.web_sg.id
  description              = "Allow HTTP traffic from Application Load Balancer to web servers"
}

# SSH ingress rule - for administrative access to web servers
# Note: In production, this should be restricted to specific IP ranges
resource "aws_security_group_rule" "web_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # For testing only; restrict to specific IPs in production
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow SSH access for server administration and troubleshooting"
}

# Egress rule for web servers - allows outbound internet access via NAT Gateway
# Required for yum updates, package installations, and external API calls
resource "aws_security_group_rule" "web_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow all outbound traffic for system updates and internet access via NAT Gateway"
}

# Security Group for internal instance communication within the VPC
# Allows instances to communicate securely with each other (e.g., database connections, internal APIs)
resource "aws_security_group" "internal_sg" {
  name        = "internal-sg"
  description = "Security group for internal VPC communication between instances"
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "internal-sg" },
    var.vpc_id != "" ? { "CreatedFor" = "CA3-Terraform" } : {}
  )
}

# Internal ingress rule - allows all traffic from within the VPC CIDR
# Enables instances to communicate with each other for distributed applications
resource "aws_security_group_rule" "internal_ingress_vpc_cidr" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.internal_sg.id
  description       = "Allow all internal traffic from VPC CIDR for instance-to-instance communication"
}

# Internal egress rule - allows outbound traffic within the VPC
resource "aws_security_group_rule" "internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.internal_sg.id
  description       = "Allow all outbound traffic to VPC CIDR for internal communications"
}

# Security Group for Application Load Balancer (ALB)
# The ALB sits in public subnets and distributes traffic to web servers in private subnets
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer. Allows HTTP/HTTPS traffic from internet."
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "alb-sg" },
    var.vpc_id != "" ? { "CreatedFor" = "CA3-Terraform" } : {}
  )
}

# ALB ingress rule - allows HTTP traffic from the internet
# In production, consider adding HTTPS (port 443) and restricting IP ranges
resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTP traffic from internet to Application Load Balancer"
}

# ALB egress rule - allows ALB to communicate with web servers
# This rule enables the ALB to forward traffic to the backend instances
resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow ALB to forward traffic to web servers and perform health checks"
}
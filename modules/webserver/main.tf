# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]  # Official AWS account
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Amazon Linux 2 HVM with GP2 root volume
  }
}

# Determine which AMI to use: custom AMI from variable or latest Amazon Linux 2
locals {
  # If var.ami is provided, use it; otherwise use the data source AMI ID
  final_ami = var.ami != "" ? var.ami : data.aws_ami.amazon_linux_2.id
}

# EC2 instance resource for web server
resource "aws_instance" "web" {
  ami           = local.final_ami        # Use the determined AMI
  instance_type = var.instance_type      # Instance size (e.g., t3.micro)
  subnet_id     = var.subnet_id          # Subnet where instance will be launched
  key_name      = var.key_name           # SSH key pair for instance access
  
  # Security groups to attach (allows inbound/outbound traffic rules)
  vpc_security_group_ids = var.security_group_ids
  
  # User data script executed on first boot
  # Note: Using EOF delimiter with '-' to remove leading whitespace
  user_data = <<-EOF
              #!/bin/bash
              # Update system packages
              yum update -y
              
              # Install Apache HTTP server
              yum install -y httpd
              
              # Enable Apache to start automatically on system boot
              systemctl enable httpd
              
              # Start Apache service immediately
              systemctl start httpd
              
              # Create simple HTML page with instance hostname
              echo "<h1>Terraform Webserver OK - $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  # Resource tags for identification and cost allocation
  tags = { 
    Name    = "terraform-webserver",   # Instance name
    Project = "CA3-Terraform"          # ID
  }
}
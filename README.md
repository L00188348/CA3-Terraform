# CA3 Terraform Assignment - High Availability Web Infrastructure

## Project Overview
Terraform project deploying a highly available web infrastructure on AWS with multi-AZ deployment, load balancing, and secure networking. This project implements the exact architecture specified in the assignment requirements with web servers in private subnets, NAT Gateway for outbound access, and an Application Load Balancer for traffic distribution.

## Architecture Diagram

                           Internet
                              |
                              ↓
                    Application Load Balancer
                    (Public Subnets: 10.0.1.0/24, 10.0.2.0/24)
                              |
                ┌─────────────┴─────────────┐
                ↓                           ↓
       Web Server AZ1              Web Server AZ2
(Private Subnet: 10.0.10.0/24)    (Private Subnet: 10.0.20.0/24)
                |                           |
                └─────────────┬─────────────┘
                              ↓
                        NAT Gateway
                (Public Subnets for outbound traffic)


## Project Structure
CA3-Terraform/
├── modules/ # Reusable Terraform modules
│ ├── vpc/ # VPC, subnets, route tables, NAT Gateway
│ ├── security/ # Security groups and network rules
│ ├── webserver/ # EC2 instances with Apache web server
│ └── alb/ # Application Load Balancer configuration
├── envs/ # Environment configurations
│ └── dev/ # Development environment
│ ├── main.tf # Root module configuration
│ ├── outputs.tf # Output definitions
│ └── .terraform/ # Local Terraform cache (gitignored)
├── .gitignore # Git ignore patterns
├── README.md # This file
└── LICENSE.txt # Project license


## Core Components

### 1. **Networking (VPC Module)**
- **VPC**: `10.0.0.0/16` CIDR block
- **Public Subnets**: `10.0.1.0/24`, `10.0.2.0/24` (us-east-1a, us-east-1b)
- **Private Subnets**: `10.0.10.0/24`, `10.0.20.0/24` (us-east-1a, us-east-1b)
- **Internet Gateway**: For public subnet internet access
- **NAT Gateway**: For private subnet outbound internet access (one per AZ)
- **Route Tables**: Separate routes for public and private subnets

### 2. **Compute (Web Server Module)**
- **EC2 Instances**: t3.micro with Amazon Linux 2
- **Apache Web Server**: Auto-installed via user_data
- **Placement**: One web server per availability zone in private subnets
- **High Availability**: Multi-AZ deployment for fault tolerance

### 3. **Load Balancing (ALB Module)**
- **Application Load Balancer**: Distributes HTTP traffic across web servers
- **Target Groups**: With health checks on port 80
- **Listener**: HTTP traffic on port 80
- **Security**: Accessible only from ALB security group

### 4. **Security (Security Module)**
- **Web Server SG**: Allows HTTP from ALB and SSH for administration
- **ALB SG**: Allows HTTP from internet, forwards to web servers
- **Internal SG**: Allows all traffic within VPC CIDR
- **Principle**: Least privilege with specific source security groups

## Assignment Compliance

This implementation follows **exactly** the requirements from the assignment PDF:

### ✅ **Fully Implemented Requirements:**
1. **VPC with CIDR 10.0.0.0/16** ✓
2. **2 Public Subnets**: `10.0.1.0/24`, `10.0.2.0/24` 
3. **2 Private Subnets**: `10.0.10.0/24`, `10.0.20.0/24` 
4. **2 Web Servers**: 1 per AZ in **private subnets** 
5. **Apache HTTPD**: Installed via user_data bootstrap 
6. **Application Load Balancer**: Public-facing with round-robin distribution 
7. **NAT Gateway**: Properly configured for outbound access 
8. **Security Groups**: With appropriate ingress/egress rules 
9. **Route Tables**: Correct routing for public/private subnets 

### 🔧 **Architecture Decisions:**
1. **Web Servers in Private Subnets**: Enhances security by preventing direct internet access
2. **NAT Gateway per AZ**: Ensures high availability for outbound traffic
3. **ALB in Public Subnets**: Accepts internet traffic and forwards to private instances
4. **Security Group References**: Uses source_security_group_id for precise access control

## Quick Start

### Prerequisites
- **AWS Account** with appropriate permissions
- **AWS CLI** configured with credentials
- **Terraform** >= 1.0.0
- **Git** for cloning the repository

### Deployment Steps

```bash
# 1. Clone the repository
git clone https://github.com/L00188348/CA3-Terraform.git
cd CA3-Terraform/envs/dev/

# 2. Initialize Terraform
terraform init

# 3. Review the execution plan
terraform plan

# 4. Deploy the infrastructure
terraform apply
# Type 'yes' when prompted to confirm

# 5. Test the deployment
terraform output alb_url
# Visit the URL in your browser or use curl

# 6. Verify load balancing (run multiple times)
for i in {1..5}; do
  curl -s http://$(terraform output -raw alb_dns_name) | grep -o "Terraform Webserver OK.*"
  sleep 1
done

Expected Output
You should see responses alternating between:

Terraform Webserver OK - ip-10-0-10-xxx.ec2.internal (AZ1)

Terraform Webserver OK - ip-10-0-20-xxx.ec2.internal (AZ2)

This confirms proper load balancing across both availability zones.


Testing and Validation
1. Load Balancing Test
# Verify traffic distribution between AZs
for i in {1..10}; do
  curl -s http://$(terraform output -raw alb_dns_name) | grep -o "ip-10-0-[0-9]*-[0-9]*"
done

Outputs
After deployment, Terraform provides these key outputs:

bash
terraform output

# Key outputs include:
# - alb_dns_name: DNS to access the application
# - vpc_id: VPC identifier for integration
# - web_sg_id: Security group for web servers
# - nat_gateway_public_ips: NAT Gateway IPs for whitelisting
# - deployment_summary: Infrastructure overview

Cleanup
terraform destroy

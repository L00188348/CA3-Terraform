# CA3 Terraform Assignment - High Availability Web Infrastructure

## Project Overview
Terraform project deploying a highly available web infrastructure on AWS with multi-AZ deployment, load balancing, and secure networking.

## Architecture

CA3-Terraform/
├─ .github/
│  └─ workflows/ci.yml
├─ modules/
│  ├─ vpc/              # Networking infrastructure
|  ├── security/        # Security groups and rules
│  ├─ webserver/        # EC2 instances with Apache
│  └─ alb/              # Application Load Balancer
├─ envs/
│  └─ dev/              # Development environment
│     ├─ main.tf
│     ├─ variables.tf
│     └─ outputs.tf
├─ README.md
└─ .gitignore

### Core Components:
- **VPC** with public and private subnets across 2 Availability Zones
- **Application Load Balancer** for traffic distribution
- **Apache Web Servers** with auto-scaling capabilities
- **NAT Gateway** for private subnet internet access
- **Security Groups** following least-privilege principle

## Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- Git

### Deployment
```bash
# Clone the repository
git clone https://github.com/L00188348/CA3-Terraform.git
cd CA3-Terraform/envs/dev/

# Initialize and deploy
terraform init
terraform plan
terraform apply

# Test the deployment
curl http://$(terraform output -raw alb_dns_name)

# Check all outputs
terraform output

# Test load balancing (should alternate between servers)
for i in {1..3}; do
  curl -s http://$(terraform output -raw alb_dns_name) | grep "ip-10-0"
done

# Test individual web servers
curl http://$(terraform output -raw webserver_az1_public_ip)
curl http://$(terraform output -raw webserver_az2_public_ip)

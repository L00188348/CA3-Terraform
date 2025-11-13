output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}
output "public_subnet_cidrs" {
  description = "CIDRs of public subnets"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "CIDRs of private subnets"
  value       = module.vpc.private_subnet_cidrs
}

output "webserver_instance_id" {
  value = module.webserver.instance_id
}

output "webserver_instance_public_ip" {
  value = module.webserver.instance_public_ip
}

output "webserver_instance_public_dns" {
  value = module.webserver.instance_public_dns
}
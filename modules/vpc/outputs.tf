output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway associado à VPC"
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "Lista de CIDRs das subnets públicas"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_azs" {
  description = "Lista de AZs usadas nas subnets públicas"
  value       = aws_subnet.public[*].availability_zone
}

output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "Lista de CIDRs das subnets privadas"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_azs" {
  description = "Lista de AZs usadas nas subnets privadas"
  value       = aws_subnet.private[*].availability_zone
}
output "vpc_cidr_block" {
  description = "CIDR da VPC"
  value       = aws_vpc.this.cidr_block
}

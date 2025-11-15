provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "IGW" })
}

# Route Table pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "Public-RT" })
}

# Rota padrão para a internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "Public-${count.index}" })
}

# Associação das public subnets com a route table pública
resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = merge(var.tags, { Name = "Private-${count.index}" })
}

# --- NAT Gateway Resources ---

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = length(var.public_subnets)
  domain = "vpc"
  
  tags = merge(var.tags, { 
    Name = "NAT-EIP-${count.index}" 
  })
}

# NAT Gateways (one in each public subnet)
resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = merge(var.tags, { 
    Name = "NAT-GW-${count.index}" 
  })
  
  depends_on = [aws_internet_gateway.this]
}

# Route Table for private subnets
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.this.id
  
  tags = merge(var.tags, { 
    Name = "Private-RT-${count.index}" 
  })
}

# Route to the internet via NAT Gateway
resource "aws_route" "private_nat" {
  count                  = length(var.private_subnets)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
  
  depends_on = [aws_nat_gateway.this]
}

# Association of private subnets with private route tables
resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
variable "vpc_id" {
  description = "ID da VPC onde os SGs serão criados"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR da VPC (usado para regras internas entre instâncias)"
  type        = string
}

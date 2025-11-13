# Variável para o keypair AWS usado no webserver
variable "key_name" {
  description = "Nome do keypair AWS para SSH."
  type        = string
  default     = ""  # substitui pelo nome do teu keypair se tiver
}

# Variável para definir qual IP pode acessar via SSH
variable "allowed_ssh_cidr" {
  description = "IP ou range permitido para SSH no Security Group do webserver."
  type        = string
  default     = "0.0.0.0/0"  # para testes;
}

# referência ao CIDR da VPC
variable "vpc_cidr_block" {
  description = "CIDR da VPC (usado pelo módulo security)."
  type        = string
  default     = "10.0.0.0/16"  # corresponde à VPC que criaste
}

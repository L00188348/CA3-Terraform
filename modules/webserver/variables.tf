variable "subnet_id" {
  description = "ID da subnet pública onde a instância será lançada"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
  default     = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "Nome do key-pair para SSH (opcional)"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "Lista de security group IDs a associar na instância"
  type        = list(string)
  default     = []
}

# Variable for the AWS keypair used in the webserver
variable "key_name" {
  description = "Name of the AWS keypair for SSH."
  type        = string
  default     = ""  
}

# Variable to define which IP can access via SSH
variable "allowed_ssh_cidr" {
  description = "IP or range allowed for SSH in the webserver Security Group."
  type        = string
  default     = "0.0.0.0/0"  # for testing;
}

# reference to the VPC CIDR
variable "vpc_cidr_block" {
  description = "CIDR of the VPC (used by the security module)."
  type        = string
  default     = "10.0.0.0/16"  # corresponds to the VPC you created
}

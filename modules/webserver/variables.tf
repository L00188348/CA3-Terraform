variable "subnet_id" {
  description = "ID of the public subnet where instance will be launched"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "Name of the key-pair for SSH"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}

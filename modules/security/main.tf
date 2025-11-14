resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH from the Internet"
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "web-sg" },
    var.vpc_id != "" ? { "CreatedFor" = "CA3-Terraform" } : {}
  )
}

resource "aws_security_group_rule" "web_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group" "internal_sg" {
  name        = "internal-sg"
  description = "Allow internal VPC communication between instances"
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "internal-sg" },
    var.vpc_id != "" ? { "CreatedFor" = "CA3-Terraform" } : {}
  )
}

resource "aws_security_group_rule" "internal_ingress_vpc_cidr" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.internal_sg.id
}

resource "aws_security_group_rule" "internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.internal_sg.id
}

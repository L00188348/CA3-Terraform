output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "internal_sg_id" {
  value = aws_security_group.internal_sg.id
}

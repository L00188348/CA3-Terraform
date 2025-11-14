data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  final_ami = var.ami != "" ? var.ami : data.aws_ami.amazon_linux_2.id
}

resource "aws_instance" "web" {
  ami           = local.final_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  security_groups = var.security_group_ids

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Terraform Webserver OK</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "terraform-webserver" }
}

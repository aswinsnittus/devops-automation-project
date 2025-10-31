provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "ubuntu_22_04_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_security_group" "web_sg" {
  name        = "devops-web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.ubuntu_22_04_ami.value
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  tags                        = { Name = "devops-web" }
}

output "public_ip" { value = aws_instance.web.public_ip }

variable "aws_region" { default = "us-east-1" }
variable "instance_type" { default = "t3.micro" }
variable "ssh_key_name" { default = "devops-key" }
variable "ssh_private_key_path" { default = "C:/Users/aswin/.ssh/devops-key.pem" }
variable "docker_image" { default = "aswinsnittu/devops-ui:v1.0.0" }

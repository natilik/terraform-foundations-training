terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

########################################
# Data calls 
########################################
# Get the latest Ubuntu AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "http" "current_ip" {
  url = "https://ifconfig.me/ip"
}

########################################
# Security 
########################################
resource "aws_security_group" "developing_modules_lab" {
  name        = "PermitLabAccess"
  description = "Allow accses to VM from current public IP."
  vpc_id      = var.vpc_id
  ingress {
    description = "PermitSSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.current_ip.response_body}/32"]
  }
  egress {
    description = "PermitInternet"
    from_port   = 0
    to_port     = 65534
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# SSH Keys
########################################
resource "tls_private_key" "developing_modules_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "developing_modules_lab" {
  key_name   = "developing_modules_lab"
  public_key = tls_private_key.developing_modules_lab.public_key_openssh
}

########################################
# Server Deployment
########################################
resource "aws_network_interface" "developing_modules_lab" {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.developing_modules_lab.id]
  tags = {
    Name = "nic-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_instance" "developing_modules_lab" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_size
  key_name      = aws_key_pair.developing_modules_lab.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.developing_modules_lab.id
  }
  tags = {
    Name = "ec2-hcl-basics-lab-${var.student_name}"
  }
}

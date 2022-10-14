terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

# Empty block as Terraform is going to use the credentials
# cached by running "aws configure".
provider "aws" {}
provider "http" {}


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

# Get the current public IP the machine running Terraform appears from.
data "http" "current_ip" {
  url = "https://ifconfig.me/ip"
}

########################################
# Networking
########################################
resource "aws_vpc" "hcl_basics_lab" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_subnet" "hcl_basics_lab" {
  vpc_id                  = aws_vpc.hcl_basics_lab.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_internet_gateway" "hcl_basics_lab" {
  vpc_id = aws_vpc.hcl_basics_lab.id
  tags = {
    Name = "igw-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_route_table" "hcl_basics_lab" {
  vpc_id = aws_vpc.hcl_basics_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hcl_basics_lab.id
  }
  tags = {
    Name = "rt-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_route_table_association" "hcl_basics_lab" {
  subnet_id      = aws_subnet.hcl_basics_lab.id
  route_table_id = aws_route_table.hcl_basics_lab.id
}

########################################
# Security 
########################################
resource "aws_security_group" "hcl_basics_lab" {
  name        = "PermitLabAccess"
  description = "Allow accses to VM from current public IP."
  vpc_id      = aws_vpc.hcl_basics_lab.id
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
resource "tls_private_key" "hcl_basics_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "hcl_basics_lab" {
  content  = tls_private_key.hcl_basics_lab.private_key_pem
  filename = "./vm-private-key.pem"
}

resource "aws_key_pair" "hcl_basics_lab" {
  key_name   = "hcl_basics_lab"
  public_key = tls_private_key.hcl_basics_lab.public_key_openssh
}

########################################
# Server Deployment
########################################
resource "aws_network_interface" "hcl_basics_lab" {
  subnet_id       = aws_subnet.hcl_basics_lab.id
  security_groups = [aws_security_group.hcl_basics_lab.id]
  tags = {
    Name = "nic-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_instance" "hcl_basics_lab" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.hcl_basics_lab.key_name
  network_interface {
    device_index         = 0
    network_interface_id = # REPLACE_ME
  }
  tags = {
    Name = "ec2-hcl-basics-lab-${var.student_name}"
  }
}

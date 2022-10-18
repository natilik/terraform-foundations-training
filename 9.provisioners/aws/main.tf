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
resource "aws_vpc" "provisioner_lab" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-provisioner-lab-${var.student_name}"
  }
}

resource "aws_subnet" "provisioner_lab" {
  vpc_id                  = aws_vpc.provisioner_lab.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-provisioner-lab-${var.student_name}"
  }
}

resource "aws_internet_gateway" "provisioner_lab" {
  vpc_id = aws_vpc.provisioner_lab.id
  tags = {
    Name = "igw-provisioner-lab-${var.student_name}"
  }
}

resource "aws_route_table" "provisioner_lab" {
  vpc_id = aws_vpc.provisioner_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.provisioner_lab.id
  }
  tags = {
    Name = "rt-provisioner-lab-${var.student_name}"
  }
}

resource "aws_route_table_association" "provisioner_lab" {
  subnet_id      = aws_subnet.provisioner_lab.id
  route_table_id = aws_route_table.provisioner_lab.id
}

########################################
# Security 
########################################
resource "aws_security_group" "provisioner_lab" {
  name        = "PermitLabAccess"
  description = "Allow accses to VM from current public IP."
  vpc_id      = aws_vpc.provisioner_lab.id
  dynamic "ingress" {
    for_each = toset([22, 80])
    content {
      description = "Permit ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${data.http.current_ip.response_body}/32"]
    }
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
resource "tls_private_key" "provisioner_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "provisioner_lab" {
  content  = tls_private_key.provisioner_lab.private_key_pem
  filename = "./vm-private-key.pem"
}

resource "aws_key_pair" "provisioner_lab" {
  key_name   = "kp-provisioner_lab-${var.student_name}"
  public_key = tls_private_key.provisioner_lab.public_key_openssh
}

########################################
# Server Deployment
########################################
resource "aws_network_interface" "provisioner_lab" {
  subnet_id       = aws_subnet.provisioner_lab.id
  security_groups = [aws_security_group.provisioner_lab.id]
  tags = {
    Name = "nic-provisioner-lab-${var.student_name}"
  }
}

resource "aws_instance" "provisioner_lab" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.provisioner_lab.key_name
  user_data     = file("./files/install_httpd.sh")
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.provisioner_lab.id
  }
  tags = {
    Name = "ec2-provisioner-lab-${var.student_name}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.provisioner_lab.private_key_pem
    host        = self.public_ip
  }

  # Used in step 3.
  # provisioner "remote-exec" {
  #   inline = [
  #     "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
  #     "sudo mv /home/ubuntu/index.html /var/www/html/index.html",
  #     "sudo systemctl restart apache2"
  #   ]
  # }
}


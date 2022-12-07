terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

########################################
# Networking
########################################
resource "aws_vpc" "developing_modules_lab" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_subnet" "developing_modules_lab" {
  vpc_id                  = aws_vpc.developing_modules_lab.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_internet_gateway" "developing_modules_lab" {
  vpc_id = aws_vpc.developing_modules_lab.id
  tags = {
    Name = "igw-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_route_table" "developing_modules_lab" {
  vpc_id = aws_vpc.developing_modules_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.developing_modules_lab.id
  }
  tags = {
    Name = "rt-hcl-basics-lab-${var.student_name}"
  }
}

resource "aws_route_table_association" "developing_modules_lab" {
  subnet_id      = aws_subnet.developing_modules_lab.id
  route_table_id = aws_route_table.developing_modules_lab.id
}

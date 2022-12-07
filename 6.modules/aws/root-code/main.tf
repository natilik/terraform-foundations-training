terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

provider "aws" {}

module "networking" {
  source       = "../modules/aws_networking"
  student_name = var.student_name
}

module "ec2" {
  source        = "../modules/aws_ec2"
  student_name  = var.student_name
  subnet_id     = module.networking.subnet_id
  vpc_id        = module.networking.vpc_id
  instance_size = "t3.micro"
}

resource "local_file" "module_lab" {
  content         = module.ec2.tls_private_key
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}

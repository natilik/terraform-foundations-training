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
  source = "../modules/aws_networking"
  # This section needs populating with the relevant variable inputs 
  # that the networking module expects.
}

module "ec2" {
  source = "../modules/aws_ec2"
  # This section needs populating with the relevant variable inputs 
  # that the networking module expects.
  # If you get stuck, take a look at https://developer.hashicorp.com/terraform/language/expressions/references#child-module-outputs
}

resource "local_file" "module_lab" {
  content         = module.ec2.tls_private_key
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}

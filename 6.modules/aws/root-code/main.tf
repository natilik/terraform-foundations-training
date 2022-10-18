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

  # Populate me with the required variable inputs.
}

module "ec2" {
  source = "../modules/aws_ec2"

  # Populate me with the required variable inputs.
  # Consider a variable input here likely depends on an output from networking.
}

output "public_ip" {
  value = # Fill me in
}

output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.module_lab.filename} ubuntu@${module.ec2.public_ip}"
}

resource "local_file" "module_lab" {
  content  = # Fill me in
  file_permission = "600"
  filename = "./vm-private-key.pem"
}

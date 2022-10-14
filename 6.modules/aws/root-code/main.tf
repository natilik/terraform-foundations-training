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

output "ec2_ip" {
  value = # Fill me in
}


# This will define one resource type in addition to module calls - local_file.
# local_file should write the output of the tls_private_key from the ec2 module to a file.
# Have a think about how you will need to do this.
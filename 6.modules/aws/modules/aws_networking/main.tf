terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

provider "aws" {}

# Create your networking resources here - based on your working code from the hcl_basics lab.

# This file should contain the following resources:
#   * The http.current_ip data object.
#   * The aws_vpc resource.
#   * The aws_subnet resource.
#   * The aws_internet_gateway resource. 
#   * The aws_route_table resource.
#   * The aws_route_table_association resource.





locals {
  for_names   = [for person in var.people : person.name]
  splat_names = var.people[*].name
}

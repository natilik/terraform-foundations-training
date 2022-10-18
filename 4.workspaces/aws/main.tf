terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

# Don't worry about these locals just yet - we will look at these later in the course.
locals {
  cidr_blocks = {
    default = "10.100.0.0/16"
    env1    = "10.101.0.0/16"
    env2    = "10.102.0.0/16"
  }
}

########################################
# Networking
########################################
resource "aws_vpc" "workspaces_lab" {
  cidr_block = lookup(local.cidr_blocks, terraform.workspace)
  tags = {
    Name = "vpc-workspaces-lab-${var.student_name}-${terraform.workspace}"
  }
}


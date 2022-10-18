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
  bucket_names = {
    default = "${random_string.workspaces_lab.result}-${var.student_name}-default"
    env1    = "${random_string.workspaces_lab.result}-${var.student_name}-env1"
    env2    = "${random_string.workspaces_lab.result}-${var.student_name}-env2"
  }
}

resource "random_string" "workspaces_lab" {
  length  = 10
  special = false
  upper   = false
}

resource "aws_s3_bucket" "workspaces_lab" {
  bucket = lookup(local.bucket_names, terraform.workspace)
  tags = {
    Name = lookup(local.bucket_names, terraform.workspace)
  }
}



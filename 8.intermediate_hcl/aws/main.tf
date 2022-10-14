terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "random" {}

provider "aws" {
  region = "eu-west-2"
}

locals {
  bucket_name = # Fill me in
  common_tags = {
    deployer    = "terraform"
    cost_centre = "abc1234"
    environment = var.environment
  }
}

resource "random_string" "bucket_prefix" {
  length  = 10
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  tags = {
    "Name" = local.bucket_name
  }
}

# Used in lab part 2, task 3.
# resource "aws_s3_bucket" "additional_bucket" {
#   bucket = "${local.bucket_name}-additional"
#   tags = {
#     "Name" = local.bucket_name
#   }
# }

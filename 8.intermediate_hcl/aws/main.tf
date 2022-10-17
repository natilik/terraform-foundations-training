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
  bucket_name = "${random_string.bucket_prefix.result}-${lower(var.student_name)}"
  common_tags = {
    deployer    = "terraform"
    cost_centre = "abc1234"
    environment = var.environment
  }
}

resource "random_string" "bucket_prefix" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  count  = 2
  bucket = "${local.bucket_name}-${count.index}"
  tags = merge(
    {
      "Name" = "${local.bucket_name}-${count.index}"
    },
    local.common_tags
  )
}

# Used in lab part 2, task 3.
resource "aws_s3_bucket" "additional_bucket" {
  count  = var.additional_bucket_enabled ? 1 : 0
  bucket = "${local.bucket_name}-additional"
  tags = {
    "Name" = local.bucket_name
  }
  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
    }
  }
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    aws = {
      source = "hashicorp/aws"
      # Please constrain me to version 4.29.0
    }
  }
}


provider "random" {}

provider "aws" {
  region = "eu-west-1"
}

# You need to create another aws provider block that will be usable below.

resource "random_string" "bucket_prefix" {
  length  = 10
  special = false
  upper   = false
}

resource "aws_s3_bucket" "eu_west_1_bucket" {
  bucket = "${random_string.bucket_prefix.result}-eu-west-1"
  tags = {
    Name = "${random_string.bucket_prefix.result}-eu-west-1"
  }
}

resource "aws_s3_bucket" "eu_west_2_bucket" {
  # Something needs changing here to use the new provider block you created above.
  bucket = "${random_string.bucket_prefix.result}-eu-west-2"
  tags = {
    Name = "${random_string.bucket_prefix.result}-eu-west-2"
  }
}

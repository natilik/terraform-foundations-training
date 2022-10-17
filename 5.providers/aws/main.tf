terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
    # AWS needs pinning to version 4.29.0
  }
}


provider "random" {}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "west2"
  region = "eu-west-2"
}


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
  provider = aws.west2
  bucket   = "${random_string.bucket_prefix.result}-eu-west-2"
  tags = {
    Name = "${random_string.bucket_prefix.result}-eu-west-2"
  }
}

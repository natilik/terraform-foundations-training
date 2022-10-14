terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    # AWS needs pinning to version 4.29.0
  }
}


provider "random" {}

provider "aws" {
  region = "eu-west-1"
}

# New provider block required.

resource "random_string" "eu_west_1_bucket" {
  length  = 10
  special = false
  upper   = false
}

resource "random_string" "eu_west_2_bucket" {
  length  = 10
  special = false
  upper   = false
}


# The resource below should deploy to eu-west-1.
resource "aws_s3_bucket" "eu_west_1_bucket" {
  bucket = random_string.eu_west_1_bucket.result
  tags = {
    Name = random_string.eu_west_1_bucket.result
  }
}

# The resource below should deploy to eu-west-2.
resource "aws_s3_bucket" "eu_west_2_bucket" {
  bucket = random_string.eu_west_2_bucket.result
  tags = {
    Name = random_string.eu_west_2_bucket.result
  }
}

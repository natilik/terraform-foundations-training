terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.12.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_secretsmanager_secret" "versioning" {
  name                    = "${var.student_name}-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_policy" "versioning" {
  secret_arn = aws_secretsmanager_secret.versioning.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAnotherAWSAccountToReadTheSecret",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_caller_identity.current.arn}"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}

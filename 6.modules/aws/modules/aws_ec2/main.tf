terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
  }
}

# Create your EC2 resources here - based on your working code from the hcl_basics lab.

# This file should contain the following resources:
#   * The http.current_ip data object.
#   * The aws_ami.ubunut data object.
#   * The aws_security_group resource.
#   * The tls_private_key resource.
#   * The aws_key_pair resource.
#   * The aws_network_interface resource.
#   * The aws_instance resource.

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.2"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/random/3.4.2
provider "random" {}

resource "random_string" "hello_world" {
  length           = 10
  special          = true
  numeric          = true
  override_special = "/,.#"
}

output "hello_world" {
  value = random_string.hello_world.result
}



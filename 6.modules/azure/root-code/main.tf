terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "modules_lab" {
  name     = "rg-hcl-basics-${var.student_name}"
  location = "uksouth"
}


module "networking" {
  source = "../modules/azure_networking"
  # This section needs populating with the relevant variable inputs 
  # that the networking module expects.
}

module "vm" {
  source = "../modules/azure_vm"
  # This section needs populating with the relevant variable inputs 
  # that the VM module expects.
  # If you get stuck, take a look at https://developer.hashicorp.com/terraform/language/expressions/references#child-module-outputs
}

resource "local_file" "module_lab" {
  content         = module.vm.tls_private_key
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}

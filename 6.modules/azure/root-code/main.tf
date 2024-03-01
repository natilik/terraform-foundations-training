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
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}

resource "random_string" "modules_lab" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "modules_lab" {
  name     = "rg-modules-${random_string.modules_lab.result}"
  location = "uksouth"
}

module "networking" {
  source              = "../modules/azure_networking"
  student_name        = # Something needs to go here.
  resource_group_name = # A reference to the resource group above needs to go here.
  location            = # A reference to the resource group above needs to go here.
}

module "vm" {
  source              = "../modules/azure_vm"
  student_name        = # Something needs to go here.
  resource_group_name = # A reference to the resource group above needs to go here.
  location            = # A reference to the resource group above needs to go here.
  subnet_id           = # A reference to the subnet_id output from the other module needs to go here. 
}

resource "local_file" "module_lab" {
  content         = module.vm.tls_private_key
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}

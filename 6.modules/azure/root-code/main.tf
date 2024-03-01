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
  student_name        = var.student_name
  resource_group_name = azurerm_resource_group.modules_lab.name
  location            = azurerm_resource_group.modules_lab.location
}

module "vm" {
  source              = "../modules/azure_vm"
  student_name        = var.student_name
  resource_group_name = azurerm_resource_group.modules_lab.name
  location            = azurerm_resource_group.modules_lab.location
  subnet_id           = module.networking.subnet_id
  vm_size             = "Standard_B1ls"
}

resource "local_file" "module_lab" {
  content         = module.vm.tls_private_key
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}

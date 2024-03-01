terraform {
  required_version = "1.7.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.28"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "versioning_lab" {
  name     = "rg-versioning-${var.student_name}"
  location = "uksouth"
}

resource "azurerm_virtual_network" "versioning_lab" {
  name                = "vnet-versioning-${var.student_name}"
  resource_group_name = azurerm_resource_group.versioning_lab.name
  location            = azurerm_resource_group.versioning_lab.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_private_dns_resolver" "versioning_lab" {
  name                = "pdnsr-versioning-${var.student_name}"
  resource_group_name = azurerm_resource_group.versioning_lab.name
  location            = azurerm_resource_group.versioning_lab.location
  virtual_network_id  = azurerm_virtual_network.versioning_lab.id
}

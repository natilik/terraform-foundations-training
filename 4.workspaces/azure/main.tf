terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "workspaces_lab" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "workspaces_lab" {
  name     = "rg-workspaces-${var.student_name}-${terraform.workspace}"
  location = "uksouth"
}

resource "azurerm_storage_account" "workspaces_lab" {
  name                     = "${random_string.workspaces_lab.result}${terraform.workspace}"
  resource_group_name      = azurerm_resource_group.workspaces_lab.name
  location                 = azurerm_resource_group.workspaces_lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

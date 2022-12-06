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

# Don't worry about these locals just yet - we will look at these later in the course.
locals {
  rg_names = {
    default = "rg-workspaces-${var.student_name}-default"
    env1    = "rg-workspaces-${var.student_name}-env1"
    env2    = "rg-workspaces-${var.student_name}-env2"
  }
  storage_account_names = {
    default = "${random_string.workspaces_lab.result}default"
    env1    = "${random_string.workspaces_lab.result}env1"
    env2    = "${random_string.workspaces_lab.result}env2"
  }
}

resource "random_string" "workspaces_lab" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "workspaces_lab" {
  name     = lookup(local.rg_names, terraform.workspace)
  location = "uksouth"
}

resource "azurerm_storage_account" "workspaces_lab" {
  name                     = lookup(local.storage_account_names, terraform.workspace)
  resource_group_name      = azurerm_resource_group.workspaces_lab.name
  location                 = azurerm_resource_group.workspaces_lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

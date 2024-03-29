terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "random" {}

provider "azurerm" {
  features {}
}

locals {
  storage_account_base_name = # Fill me in
  storage_account_name = substr(replace(local.storage_account_base_name, "-", ""), 0, 20)
  common_tags = {
    deployer    = "terraform"
    cost_centre = "abc1234"
    environment = var.environment
  }
}

resource "random_string" "storage_account_prefix" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "intermediate_hcl" {
  name     = "rg-intermediate-hcl-${var.student_name}"
  location = "uksouth"
}

resource "azurerm_storage_account" "intermediate_hcl" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.intermediate_hcl.name
  location                 = azurerm_resource_group.intermediate_hcl.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    "Name" = "${local.storage_account_name}"
  }
}

# Used in lab part 2, task 3.
# resource "azurerm_storage_account" "additional_storage_account" {
#   name                     = "${local.storage_account_name}2"
#   resource_group_name      = azurerm_resource_group.intermediate_hcl.name
#   location                 = azurerm_resource_group.intermediate_hcl.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   tags = merge(
#     {
#       "Name" = "${local.storage_account_name}"
#     }
#   )
# }

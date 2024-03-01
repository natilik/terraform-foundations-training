terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "165cba3b-8642-4aa1-bbab-35e1140dd81b"
}

provider "azurerm" {
  features {}
  alias           = "secondary"
  subscription_id = "165cba3b-8642-4aa1-bbab-35e1140dd81b"
}

provider "random" {}

resource "random_string" "account_prefix" {
  length  = 10
  special = false
  upper   = false
}

###########################################
# Primary Resources
###########################################
resource "azurerm_resource_group" "primary_subscription" {
  name     = "rg-providers-${var.student_name}-primary"
  location = "uksouth"
}

resource "azurerm_storage_account" "primary_account" {
  name                     = "${random_string.account_prefix.result}primary"
  resource_group_name      = azurerm_resource_group.primary_subscription.name
  location                 = azurerm_resource_group.primary_subscription.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

###########################################
# Secondary Resources
###########################################
resource "azurerm_resource_group" "secondary_subscription" {
  provider = azurerm.secondary
  name     = "rg-providers-${var.student_name}-secondary"
  location = "uksouth"
}

resource "azurerm_storage_account" "secondary_subscription" {
  provider                 = azurerm.secondary
  name                     = "${random_string.account_prefix.result}secondary"
  resource_group_name      = azurerm_resource_group.secondary_subscription.name
  location                 = azurerm_resource_group.secondary_subscription.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

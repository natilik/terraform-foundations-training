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
  subscription_id = "<primary_subscription_id>"
}

provider "azurerm" {
  features {}
  alias           = "secondary_subscription"
  subscription_id = "<secondary_subscription_id>"
}

provider "random" {}

resource "random_string" "bucket_prefix" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "primary_subscription" {
  name     = "rg-providers-${var.student_name}-primary"
  location = "uksouth"
}

resource "azurerm_resource_group" "secondary_subscription" {
  provider = azurerm.secondary_subscription
  name     = "rg-providers-${var.student_name}-secondary"
  location = "uksouth"
}

resource "azurerm_storage_account" "primary_account" {
  name                     = "${random_string.bucket_prefix.result}primary"
  resource_group_name      = azurerm_resource_group.primary_subscription.name
  location                 = azurerm_resource_group.primary_subscription.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "secondary_subscription" {
  provider                 = azurerm.secondary_subscription
  name                     = "${random_string.bucket_prefix.result}secondary"
  resource_group_name      = azurerm_resource_group.secondary_subscription.name
  location                 = azurerm_resource_group.secondary_subscription.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

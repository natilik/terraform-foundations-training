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
  lowercase_student_name    = lower(var.student_name)
  storage_account_base_name = "${random_string.storage_account_prefix.result}${local.lowercase_student_name}"
  storage_account_name      = substr(replace(local.storage_account_base_name, "-", ""), 0, 20)
  common_tags = {
    deployer    = "terraform"
    cost_centre = "abc1234"
    environment = var.environment
  }
}

resource "random_string" "storage_account_prefix" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "intermediate_hcl" {
  name     = "rg-intermediate-hcl-${local.lowercase_student_name}"
  location = "uksouth"
}

resource "azurerm_storage_account" "intermediate_hcl" {
  for_each                 = toset(["a", "b"])
  name                     = "${local.storage_account_name}${each.value}"
  resource_group_name      = azurerm_resource_group.intermediate_hcl.name
  location                 = azurerm_resource_group.intermediate_hcl.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.storage_account_name}${each.value}"
    }
  )
}

# Used in lab part 2, task 3.
resource "azurerm_storage_account" "additional_storage_account" {
  count                    = var.additional_storage_account_enabled ? 1 : 0
  name                     = "${local.storage_account_name}2"
  resource_group_name      = azurerm_resource_group.intermediate_hcl.name
  location                 = azurerm_resource_group.intermediate_hcl.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = merge(
    {
      "Name" = "${local.storage_account_name}"
    }
  )
  blob_properties {
    dynamic "cors_rule" {
      for_each = var.cors_rules
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }
}

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
  }
}

########################################
# Data calls 
########################################
# Get the current public IP the machine running Terraform appears from.
data "http" "current_ip" {
  url = "https://ifconfig.me/ip"
}

########################################
# Networking
########################################
resource "azurerm_virtual_network" "modules_lab" {
  name                = "vnet-hcl-basics-${var.student_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "modules_lab" {
  name                 = "snet-hcl-basics-${var.student_name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.modules_lab.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "modules_lab" {
  name                = "nsg-hcl-basics-${var.student_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  security_rule {
    name                       = "PermitLabAccess"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = data.http.current_ip.response_body
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = 22
  }
}

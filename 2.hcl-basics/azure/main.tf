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
  }
}

# Empty block as Terraform is going to use the credentials
# cached by running "az login".
provider "azurerm" {
  features {}
}

provider "http" {}
provider "tls" {}
provider "local" {}

########################################
# Data calls 
########################################
# Get the current public IP the machine running Terraform appears from.
data "http" "current_ip" {
  url = "https://ifconfig.me/ip"
}

########################################
# Resource Group
########################################
resource "azurerm_resource_group" "hcl_basics_lab" {
  name     = "rg-hcl-basics-${var.student_name}"
  location = "uksouth"
}

########################################
# Networking
########################################
resource "azurerm_virtual_network" "hcl_basics_lab" {
  name                = "vnet-hcl-basics-${var.student_name}"
  location            = azurerm_resource_group.hcl_basics_lab.location
  resource_group_name = azurerm_resource_group.hcl_basics_lab.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "hcl_basics_lab" {
  name                 = "snet-hcl-basics-${var.student_name}"
  resource_group_name  = azurerm_resource_group.hcl_basics_lab.name
  virtual_network_name = azurerm_virtual_network.hcl_basics_lab.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "hcl_basics_lab" {
  name                = "nsg-hcl-basics-${var.student_name}"
  location            = azurerm_resource_group.hcl_basics_lab.location
  resource_group_name = azurerm_resource_group.hcl_basics_lab.name
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

resource "azurerm_subnet_network_security_group_association" "hcl_basics_lab" {
  subnet_id                 = azurerm_subnet.hcl_basics_lab.id
  network_security_group_id = azurerm_network_security_group.hcl_basics_lab.id
}


########################################
# SSH Keys
########################################
resource "tls_private_key" "hcl_basics_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "hcl_basics_lab" {
  content         = tls_private_key.hcl_basics_lab.private_key_pem
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}


##################################
# NIC, VM and Public IP
##################################
resource "azurerm_public_ip" "hcl_basics_lab" {
  name                = "pip-hcl-basics-${var.student_name}"
  resource_group_name = azurerm_resource_group.hcl_basics_lab.name
  location            = azurerm_resource_group.hcl_basics_lab.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "hcl_basics_lab" {
  name                = "nic-hcl-basics-${var.student_name}"
  location            = azurerm_resource_group.hcl_basics_lab.location
  resource_group_name = azurerm_resource_group.hcl_basics_lab.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hcl_basics_lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hcl_basics_lab.id
  }
}

resource "azurerm_linux_virtual_machine" "hcl_basics_lab" {
  name                = "vm-hcl-basics-${var.student_name}"
  resource_group_name = azurerm_resource_group.hcl_basics_lab.name
  location            = azurerm_resource_group.hcl_basics_lab.location
  size                = "Standard_B1ls"
  admin_username      = "ubuntu"
  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.hcl_basics_lab.public_key_openssh
  }
  network_interface_ids = [
    azurerm_network_interface.hcl_basics_lab.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

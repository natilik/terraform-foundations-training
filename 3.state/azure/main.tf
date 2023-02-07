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
# cached by running "aws configure".
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
resource "azurerm_resource_group" "state_lab" {
  # IMPORT ME
  # Create me manually using the instructions in az_cli_commands.txt 
  # then import to this empty placeholder. 
  # Once imported, write the configuration to match the imported values.
}

########################################
# Networking
########################################
resource "azurerm_virtual_network" "state_lab" {
  # IMPORT ME
  # Create me manually using the instructions in az_cli_commands.txt 
  # then import to this empty placeholder. 
  # Once imported, write the configuration to match the imported values.
}

resource "azurerm_subnet" "state_lab" {
  name                 = "snet-state-${var.student_name}"
  resource_group_name  = azurerm_resource_group.state_lab.name
  virtual_network_name = azurerm_virtual_network.state_lab.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "state_lab" {
  name                = "nsg-state-${var.student_name}"
  location            = azurerm_resource_group.state_lab.location
  resource_group_name = azurerm_resource_group.state_lab.name
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

resource "azurerm_subnet_network_security_group_association" "state_lab" {
  subnet_id                 = azurerm_subnet.state_lab.id
  network_security_group_id = azurerm_network_security_group.state_lab.id
}

########################################
# SSH Keys
########################################
resource "tls_private_key" "state_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "state_lab" {
  content         = tls_private_key.state_lab.private_key_pem
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}


##################################
# NIC, VM and Public IP
##################################
resource "azurerm_public_ip" "state_lab" {
  name                = "pip-state-${var.student_name}"
  resource_group_name = azurerm_resource_group.state_lab.name
  location            = azurerm_resource_group.state_lab.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "state_lab" {
  name                = "nic-state-${var.student_name}"
  location            = azurerm_resource_group.state_lab.location
  resource_group_name = azurerm_resource_group.state_lab.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.state_lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.state_lab.id
  }
}

resource "azurerm_linux_virtual_machine" "state_lab" {
  name                = "vm-state-${var.student_name}"
  resource_group_name = azurerm_resource_group.state_lab.name
  location            = azurerm_resource_group.state_lab.location
  size                = "Standard_B1ls"
  admin_username      = "ubuntu"
  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.state_lab.public_key_openssh
  }
  network_interface_ids = [
    azurerm_network_interface.state_lab.id
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

########################################
# Dummmy file
########################################
resource "local_file" "state_lab_delete_me" {
  content  = "The contents of this file should not be deleted!"
  filename = "./please_keep_me.txt"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.34.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }
}


########################################
# SSH Keys
########################################
resource "tls_private_key" "modules_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "modules_lab" {
  content         = tls_private_key.modules_lab.private_key_pem
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}


##################################
# NIC, VM and Public IP
##################################
resource "azurerm_public_ip" "modules_lab" {
  name                = "pip-modules-${var.student_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "modules_lab" {
  name                = "nic-modules-${var.student_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.modules_lab.id
  }
}

resource "azurerm_linux_virtual_machine" "modules_lab" {
  name                = "vm-modules-${var.student_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = "ubuntu"
  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.modules_lab.public_key_openssh
  }
  network_interface_ids = [
    azurerm_network_interface.modules_lab.id
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

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
resource "azurerm_resource_group" "provisioner_lab" {
  name     = "rg-provisioner-${var.student_name}"
  location = "uksouth"
}

########################################
# Networking
########################################
resource "azurerm_virtual_network" "provisioner_lab" {
  name                = "vnet-provisioner-${var.student_name}"
  location            = azurerm_resource_group.provisioner_lab.location
  resource_group_name = azurerm_resource_group.provisioner_lab.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "provisioner_lab" {
  name                 = "snet-provisioner-${var.student_name}"
  resource_group_name  = azurerm_resource_group.provisioner_lab.name
  virtual_network_name = azurerm_virtual_network.provisioner_lab.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "provisioner_lab" {
  name                = "nsg-provisioner-${var.student_name}"
  location            = azurerm_resource_group.provisioner_lab.location
  resource_group_name = azurerm_resource_group.provisioner_lab.name
  dynamic security_rule {
    for_each = toset([22, 80])
    content {
      name                       = "PermitLabAccess${security_rule.value}"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = data.http.current_ip.response_body
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = security_rule.value
  }
}

resource "azurerm_subnet_network_security_group_association" "provisioner_lab" {
  subnet_id                 = azurerm_subnet.provisioner_lab.id
  network_security_group_id = azurerm_network_security_group.provisioner_lab.id
}

########################################
# SSH Keys
########################################
resource "tls_private_key" "provisioner_lab" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "provisioner_lab" {
  content         = tls_private_key.provisioner_lab.private_key_pem
  file_permission = "600"
  filename        = "./vm-private-key.pem"
}


##################################
# NIC, VM and Public IP
##################################
resource "azurerm_public_ip" "provisioner_lab" {
  name                = "pip-provisioner-${var.student_name}"
  resource_group_name = azurerm_resource_group.provisioner_lab.name
  location            = azurerm_resource_group.provisioner_lab.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "provisioner_lab" {
  name                = "nic-provisioner-${var.student_name}"
  location            = azurerm_resource_group.provisioner_lab.location
  resource_group_name = azurerm_resource_group.provisioner_lab.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.provisioner_lab.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.provisioner_lab.id
  }
}

resource "azurerm_linux_virtual_machine" "provisioner_lab" {
  name                = "vm-provisioner-${var.student_name}"
  resource_group_name = azurerm_resource_group.provisioner_lab.name
  location            = azurerm_resource_group.provisioner_lab.location
  size                = "Standard_B1ls"
  admin_username      = "ubuntu"
  custom_data         = filebase64("./files/install_httpd.sh")
  admin_ssh_key {
    username   = "ubuntu"
    public_key = tls_private_key.provisioner_lab.public_key_openssh
  }
  network_interface_ids = [
    azurerm_network_interface.provisioner_lab.id
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

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.provisioner_lab.private_key_pem
    host        = self.public_ip_address
  }

  # Used in step 3.
  # provisioner "remote-exec" {
  #   inline = [
  #     "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
  #     "sudo mv /home/ubuntu/index.html /var/www/html/index.html",
  #     "sudo systemctl restart apache2"
  #   ]
  # }
}

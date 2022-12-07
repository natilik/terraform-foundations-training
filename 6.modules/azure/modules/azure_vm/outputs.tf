output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.modules_lab.public_ip_address
}

output "tls_private_key" {
  value = tls_private_key.modules_lab.private_key_pem
}

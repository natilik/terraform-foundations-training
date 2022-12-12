output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.provisioner_lab.filename} ubuntu@${azurerm_linux_virtual_machine.provisioner_lab.public_ip_address}"
}

output "http_url" {
  description = "The URL of the webpage on the remote resource."
  value       = "http://${azurerm_linux_virtual_machine.provisioner_lab.public_ip_address}"
}

output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.state_lab.filename} ubuntu@${azurerm_linux_virtual_machine.changed.public_ip_address}"
}

output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.hcl_basics_lab.filename} ubuntu@${azurerm_linux_virtual_machine.hcl_basics_lab.public_ip_address}"
}

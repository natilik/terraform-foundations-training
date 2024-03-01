output "vm_public_ip" {
  value = module.vm.vm_public_ip
}

output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.module_lab.filename} ubuntu@${module.vm.vm_public_ip}"
}

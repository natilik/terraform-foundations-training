output "vm_public_ip" {
  value = # This needs populating with the relevant module output.
}

output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.module_lab.filename} ubuntu@${module.ec2.ec2_public_ip}"
}

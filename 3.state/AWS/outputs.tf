output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.state_lab.filename} ubuntu@${aws_instance.state_lab.public_ip}"
}

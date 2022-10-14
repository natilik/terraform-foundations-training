output "ssh_command" {
  description = "The SSH command to connect to the newly created instance."
  value       = "ssh -i ${local_file.provisioner_lab.filename} ubuntu@${aws_instance.provisioner_lab.public_ip}"
}

output "http_url" {
  description = "The URL of the webpage on the remote resource."
  value       = "http://${aws_instance.provisioner_lab.public_ip}"
}

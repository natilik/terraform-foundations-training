output "tls_private_key" {
  value     = tls_private_key.developing_modules_lab.private_key_pem
  sensitive = true
}

output "ec2_public_ip" {
  value = aws_instance.developing_modules_lab.public_ip
}

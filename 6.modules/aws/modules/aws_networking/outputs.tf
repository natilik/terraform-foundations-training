output "vpc_id" {
  value = aws_vpc.developing_modules_lab.id
}

output "subnet_id" {
  value = aws_subnet.developing_modules_lab.id
}

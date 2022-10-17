variable "student_name" {
  type        = string
  description = "Student name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to place EC2 NIC in."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to place the security groups."
}

variable "instance_size" {
  type    = string
  default = "t3.micro"
}

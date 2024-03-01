variable "student_name" {
  description = "Please enter your student name, separated by a dash (-)."
  type        = string

  # Regex to ensure there is no space in the variable.
  validation {
    condition     = can(regex("^\\S+$", var.student_name))
    error_message = "The variable student_name should not contain a space."
  }
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1ls"
  description = "The size of the VM. Defaults to Standard_B1ls if no value is provided."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name which resources should be created in."
}

variable "location" {
  type        = string
  description = "The location the resources should be created in."
}

variable "student_name" {
  description = "Please enter your student name, separated by a dash (-)."
  type        = string

  # Regex to ensure there is no space in the variable.
  validation {
    condition     = can(regex("^\\S+$", var.student_name))
    error_message = "The variable student_name should not contain a space."
  }
}

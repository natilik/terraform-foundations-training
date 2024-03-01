variable "student_name" {
  description = "Please enter your student name, separated by a dash (-)."
  type        = string

  # Regex to ensure there is no space in the variable.
  validation {
    condition     = can(regex("^\\S+$", var.student_name))
    error_message = "The variable student_name should not contain a space."
  }
}

variable "environment" {
  type = string
}

variable "random_string_length" {
  type        = number
  default     = 10
  description = "The length of the random string prefix that is used to make up part of the storage account name."
}

# Used in lab part 2, task 3
variable "additional_storage_account_enabled" {
  description = "Whether to enable an additional bucket."
  type        = bool
}

# Used in lab part 2, task 4
variable "cors_rules" {
  description = "CORS rules for dynamic use in bucket."
  type = set(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
}

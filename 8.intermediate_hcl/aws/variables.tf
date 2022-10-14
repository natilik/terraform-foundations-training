variable "student_name" {
  description = "Please enter your student name, separated by a dash (-)."
  type        = string

  # Regex to ensure there is no space in the variable.
  validation {
    condition     = can(regex("^\\S+$", var.student_name))
    error_message = "The variable student_name should not contain a space."
  }
}

variable "environment" {}

# Used in lab part 1, task 6 
# variable "random_string_length" {
#   description = "The length of the random string to be created. Must be a value between 5 and 10."
#   type        = number
#   validation {
#     condition     = # fill me in
#     error_message = "The value of random_string_length should be between 5 and 10."
#   }
# }


# Used in lab part 2, task 3
# variable "additional_bucket_enabled" {
#   description = "Whether to enable an additional bucket."
#   type        = bool
# }

# Used in lab part 2, task 4
# variable "cors_rules" {
#   description = "CORS rules for dynamic use in bucket."
#   type        = set(map(list(string)))
# }

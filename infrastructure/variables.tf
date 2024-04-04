variable "admin_password" {
  description = "The password associated with the local administrator account."
  type        = string
  sensitive   = true
}

variable "trainee_name" {
  description = "First name and lastname of trainee to be used as prefix for each resource, without spaces and in lowercase"
  type        = string
  validation {
    condition     = length(var.trainee_name) < 46
    error_message = "Invalid IP address provided."
  }
}

variable "my_ip" {
  description = "Local IP address"
  type        = string
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.my_ip))
    error_message = "Invalid IP address provided. IP Address should be in the format xxx.xxx.xxx.xxx"
  }
}

variable "trainee_number" {
  description = "Trainee asssigned number"
  type        = number
  validation {
    condition     = var.trainee_number > 0 && var.trainee_number < 11
    error_message = "Trainee number must be a number between 1 and 10 (1 and 10 inclusive)"
  }
}

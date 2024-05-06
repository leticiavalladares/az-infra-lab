variable "trainee_name" {
  description = "First name and lastname of trainee to be used as prefix for each resource, without spaces and in lowercase"
  type        = string
  validation {
    condition     = length(var.trainee_name) < 46
    error_message = "Invalid IP address provided."
  }
}

variable "trainee_number" {
  description = "Trainee asssigned number"
  type        = number
  validation {
    condition     = var.trainee_number > 0 && var.trainee_number < 16
    error_message = "Trainee number must be a number between 1 and 15 (1 and 15 inclusive)"
  }
}

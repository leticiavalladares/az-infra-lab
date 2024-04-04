locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  location    = "Germany West Central"
  username    = "eonadmin"
  name_suffix = "eon-gwc"

  trainee_name_without_spaces     = replace(var.trainee_name, " ", "")
  trainee_name_without_dashes     = replace(local.trainee_name_without_spaces, "-", "")
  trainee_name_without_underscore = replace(local.trainee_name_without_dashes, "_", "")

  trainee_name_validated = lower(local.trainee_name_without_underscore)
}

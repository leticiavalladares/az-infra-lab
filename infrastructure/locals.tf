locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  location    = "Germany West Central"
  username    = "eonadmin"
  name_suffix = "eon-lab-gwc"
}

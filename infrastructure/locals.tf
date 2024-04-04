locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  location    = "Germany West Central"
  username    = "eonadmin"
  name_suffix = "eon-gwc"
  vnet_cidr   = "10.0.0.0/16"

  trainee_name_without_spaces     = replace(var.trainee_name, " ", "")
  trainee_name_without_dashes     = replace(local.trainee_name_without_spaces, "-", "")
  trainee_name_without_underscore = replace(local.trainee_name_without_dashes, "_", "")

  trainee_name_validated = lower(local.trainee_name_without_underscore)

  subnets = {
    1 = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 4, (var.trainee_number - 1))]
    }
    2 = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 159, (var.trainee_number - 1))]
    }
    3 = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 4, (2 - 1))]
    }
    4 = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 160, (2 - 1))]
    }
    19 = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 4, (10 - 1))]
    }
    20 = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 161, (10 - 1))]
    }
  }

}

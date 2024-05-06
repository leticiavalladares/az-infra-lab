locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  location    = "Germany West Central"
  username    = "eonadmin"
  name_suffix = "eon-lab-gwc"

  trainee_name_without_spaces     = replace(var.trainee_name, " ", "")
  trainee_name_without_dashes     = replace(local.trainee_name_without_spaces, "-", "")
  trainee_name_without_underscore = replace(local.trainee_name_without_dashes, "_", "")

  trainee_name_validated = lower(local.trainee_name_without_underscore)

  subnets = {
    1 = {
      address_prefixes = [cidrsubnet(data.azurerm_virtual_network.vnet.address_space[0], 4, (var.trainee_number - 1))]
    }
    2 = {
      address_prefixes = [cidrsubnet(data.azurerm_virtual_network.vnet.address_space[0], 10, (var.trainee_number + 959))]
    }
    3 = {
      address_prefixes = [cidrsubnet(data.azurerm_virtual_network.vnet.address_space[0], 10, (var.trainee_number + 974))]
    }
  }
}

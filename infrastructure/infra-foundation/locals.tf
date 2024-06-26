locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  location    = "Germany West Central"
  name_suffix = "eon-lab-gwc"
  vnet_cidr   = "192.168.0.0/16"

  subnets = {
    AzureBastionSubnet = {
      address_prefixes = [cidrsubnet(local.vnet_cidr, 10, 1023)]
    }
  }
}

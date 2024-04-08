data "azurerm_subnet" "node_snet" {
  name                 = "${local.trainee_name_validated}-${local.name_suffix}-1-snet"
  resource_group_name  = "${local.name_suffix}-vnet-rg"
  virtual_network_name = "${local.name_suffix}-vnet"
}

# data "azurerm_private_dns_zone" "private_dns_zone" {
#   name                = "privatelink.germanywestcentral.azmk8s.io"
#   resource_group_name = "${local.name_suffix}-vnet-rg"
# }

data "azurerm_user_assigned_identity" "user_id" {
  name                = "${local.name_suffix}-id"
  resource_group_name = "${local.name_suffix}-vnet-rg"
}

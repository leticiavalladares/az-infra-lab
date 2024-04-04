# data "azurerm_resource_group" "vnet_rg" {
#   name = "${local.name_suffix}-vnet-rg"
# }

# data "azurerm_virtual_network" "vnet" {
#   name                = "${local.name_suffix}-vnet"
#   resource_group_name = data.azurerm_resource_group.vnet_rg.name
# }

data "azurerm_resource_group" "vnet_rg" {
  name = "${local.name_suffix}-vnet-rg"
}

data "azurerm_subnet" "node_snet" {
  name                 = "${local.trainee_name_validated}-${local.name_suffix}-1-snet"
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name = "${local.name_suffix}-vnet"
}

data "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = "eon-lab-gwc-bvault"
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

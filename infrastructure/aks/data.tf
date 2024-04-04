data "azurerm_subnet" "node_snet" {
  name                 = "${local.trainee_name_validated}-${local.name_suffix}-2-snet"
  resource_group_name  = "${local.name_suffix}-vnet-rg"
  virtual_network_name = "${local.name_suffix}-vnet"
}

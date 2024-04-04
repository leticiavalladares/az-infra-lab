data "azurerm_subnet" "node_snet" {
  name                 = "${local.trainee_name_validated}-${local.name_suffix}-3-snet"
  resource_group_name  = "${local.trainee_name_validated}-${local.name_suffix}-rg"
  virtual_network_name = "${local.trainee_name_validated}-${local.name_suffix}-vnet"
}

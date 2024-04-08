data "azurerm_public_ip" "bastion_pip" {
  name                = "${local.name_suffix}-pip"
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

resource "azurerm_route_table" "rt" {
  name                          = "${local.name_suffix}-rt"
  location                      = data.azurerm_resource_group.vnet_rg.location
  resource_group_name           = data.azurerm_resource_group.vnet_rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "${local.name_suffix}-aks-route-1"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_public_ip.bastion_pip.ip_address
  }

  tags = local.default_tags
}

resource "azurerm_subnet_route_table_association" "snet_rt_assoc" {
  subnet_id      = data.azurerm_subnet.node_snet.id
  route_table_id = azurerm_route_table.rt.id
}

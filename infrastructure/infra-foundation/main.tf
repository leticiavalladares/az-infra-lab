resource "azurerm_resource_group" "vnet_rg" {
  location = local.location
  name     = "${local.name_suffix}-vnet-rg"

  tags = local.default_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.name_suffix}-vnet"
  location            = local.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = [local.vnet_cidr]

  tags = local.default_tags
}

resource "azurerm_subnet" "snet" {
  for_each = local.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_public_ip" "pip" {
  name                = "${local.name_suffix}-pip"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.default_tags
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.germanywestcentral.azmk8s.io"
  resource_group_name = azurerm_resource_group.vnet_rg.name

  tags = local.default_tags
}

resource "azurerm_user_assigned_identity" "user_id" {
  name                = "${local.name_suffix}-id"
  resource_group_name = azurerm_resource_group.vnet_rg.name
  location            = azurerm_resource_group.vnet_rg.location

  tags = local.default_tags
}

resource "azurerm_role_assignment" "user_id_role_assign" {
  for_each = toset(local.roles_uid_on_private_zone)

  scope                = azurerm_private_dns_zone.private_dns_zone.id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.user_id.principal_id
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${local.name_suffix}-bas"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  sku                 = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet["AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = local.default_tags
}

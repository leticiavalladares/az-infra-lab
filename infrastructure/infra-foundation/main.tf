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

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${local.name_suffix}-bas"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  sku                 = "Standard"
  tunneling_enabled   = true

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet["AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = local.default_tags
}

resource "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = "${local.name_suffix}-bvault"
  resource_group_name = azurerm_resource_group.vnet_rg.name
  location            = azurerm_resource_group.vnet_rg.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  soft_delete         = "Off"

  identity {
    type = "SystemAssigned"
  }

  tags = local.default_tags
}

resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "backup_policy" {
  name                = "${local.name_suffix}-bkpol"
  resource_group_name = azurerm_resource_group.vnet_rg.name
  vault_name          = azurerm_data_protection_backup_vault.backup_vault.name

  backup_repeating_time_intervals = ["R/2024-04-22T13:00:00+00:00/P1W"]
  time_zone                       = "Central European Standard Time"

  retention_rule {
    name     = "Weekly"
    priority = 25

    life_cycle {
      duration        = "P2W"
      data_store_type = "OperationalStore"
    }

    criteria {
      days_of_week = ["Tuesday"]
    }
  }

  default_retention_rule {
    life_cycle {
      duration        = "P7D"
      data_store_type = "OperationalStore"
    }
  }
}

resource "azurerm_storage_account" "backup_storage_account" {
  name                     = "${replace(local.name_suffix, "-", "")}st"
  resource_group_name      = azurerm_resource_group.vnet_rg.name
  location                 = azurerm_resource_group.vnet_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.default_tags
}

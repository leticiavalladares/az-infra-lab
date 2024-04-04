resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "${local.trainee_name_validated}-${local.name_suffix}aks-rg"

  tags = local.default_tags
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.name_suffix_for_acr}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  for_each = local.clusters

  name                = "${each.key}aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = each.value.dns_prefix

  automatic_channel_upgrade = "none"

  default_node_pool {
    name        = each.value.def_node_pool_name
    node_count  = each.value.node_count
    node_labels = each.value.node_labels
    vm_size     = each.value.vm_size
    # orchestrator_version = "v1"
  }

  node_resource_group = "mc-${local.trainee_name_validated}-${local.name_suffix}-aks-rg"

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "172.16.3.254"
    service_cidr   = "172.16.0.0/22"
  }

  identity {
    type = each.value.identity_type
  }

  tags = merge(local.default_tags, { Name = each.key })
}

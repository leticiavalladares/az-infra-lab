resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "${local.trainee_name_validated}-${local.name_suffix}aks-rg"

  tags = local.default_tags
}

resource "azurerm_kubernetes_cluster" "cluster" {
  for_each = local.clusters

  name                = "${each.key}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = each.value.dns_prefix

  default_node_pool {
    name        = each.value.def_node_pool_name
    node_count  = each.value.node_count
    node_labels = each.value.node_labels
    vm_size     = each.value.vm_size
    # orchestrator_version = "v1"
  }

  identity {
    type = each.value.identity_type
  }

  tags = merge(local.default_tags, { Name = each.key })
}

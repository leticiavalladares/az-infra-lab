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

resource "azurerm_kubernetes_cluster" "cluster" {
  for_each = local.clusters

  name                    = "${each.key}-aks"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = each.value.dns_prefix
  private_cluster_enabled = true

  private_cluster_public_fqdn_enabled = true

  default_node_pool {
    name           = each.value.def_node_pool_name
    node_count     = each.value.node_count
    node_labels    = each.value.node_labels
    vm_size        = each.value.vm_size
    vnet_subnet_id = each.value.subnet_id

    upgrade_settings {
      max_surge = "10%"
    }
  }

  node_resource_group = "${local.trainee_name_validated}-${local.name_suffix}-mc-aks-rg"

  network_profile {
    network_plugin    = "azure"
    dns_service_ip    = "10.1.0.10"
    service_cidr      = "10.1.0.0/26"
    load_balancer_sku = "standard"
    outbound_type     = "userDefinedRouting"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.user_id.id]
  }

  tags = local.default_tags

  depends_on = [azurerm_subnet_route_table_association.snet_rt_assoc]
}

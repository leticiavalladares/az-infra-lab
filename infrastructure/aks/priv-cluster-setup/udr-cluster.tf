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

  lifecycle {
    ignore_changes = [network_profile[0].load_balancer_profile[0].idle_timeout_in_minutes]
  }

  tags = local.default_tags
}

######

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone created by AKS Cluster 1"
}

resource "azurerm_role_assignment" "user_id_role_assign" {
  for_each = toset(local.roles_uid_on_private_zone)

  scope                = var.private_dns_zone_id
  role_definition_name = each.key
  principal_id         = data.azurerm_user_assigned_identity.user_id.principal_id
}

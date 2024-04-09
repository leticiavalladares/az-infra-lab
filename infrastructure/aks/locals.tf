locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  location    = "Germany West Central"
  name_suffix = "eon-lab-gwc"

  trainee_name_without_spaces     = replace(var.trainee_name, " ", "")
  trainee_name_without_dashes     = replace(local.trainee_name_without_spaces, "-", "")
  trainee_name_without_underscore = replace(local.trainee_name_without_dashes, "_", "")

  trainee_name_validated = lower(local.trainee_name_without_underscore)
  name_suffix_for_acr    = join("", [local.trainee_name_validated, replace(local.name_suffix, "-", "")])

  clusters = {
    "${local.trainee_name_validated}-${local.name_suffix}-1" = {
      dns_prefix         = "${local.trainee_name_validated}-${local.name_suffix}-1-aks"
      def_node_pool_name = "linnodepool"
      node_count         = 2
      node_labels        = { app = "nginx" }
      vm_size            = "Standard_B4s_v2"
      identity_type      = "SystemAssigned"
      subnet_id          = data.azurerm_subnet.node_snet.id
    }
  }

  roles_uid_on_private_zone = [
    "Private DNS Zone Contributor",
    "Network Contributor"
  ]
}

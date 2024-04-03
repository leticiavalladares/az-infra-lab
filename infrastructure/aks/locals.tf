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

  clusters = {
    "${local.trainee_name_validated}-${local.name_suffix}-01" = {
      dns_prefix         = "${local.trainee_name_validated}-${local.name_suffix}-01-aks"
      def_node_pool_name = "dfnodepool"
      node_count         = 3
      node_labels        = { app = "nginx" }
      vm_size            = "Standard_B4s_v2"
      identity_type      = "SystemAssigned"
    }
  }
}

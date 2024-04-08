resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "${local.trainee_name_validated}-${local.name_suffix}-aks-rg"

  tags = local.default_tags
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.name_suffix_for_acr}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  tags = local.default_tags
}

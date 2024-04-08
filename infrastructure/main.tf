resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "${local.trainee_name_validated}-${local.name_suffix}-rg"

  tags = local.default_tags
}

resource "azurerm_subnet" "snet" {
  for_each = local.subnets

  name                 = "${local.trainee_name_validated}-${local.name_suffix}-${each.key}-snet"
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
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
    next_hop_in_ip_address = data.azurerm_bastion_host.bas.ip_configuration[0].public_ip_address_id
  }

  tags = local.default_tags
}

resource "azurerm_subnet_route_table_association" "snet_rt_assoc" {
  subnet_id      = azurerm_subnet.snet["1"].id
  route_table_id = azurerm_route_table.rt.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.trainee_name_validated}-${local.name_suffix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = data.azurerm_virtual_network.vnet.address_space[0]
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowRDPInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = data.azurerm_virtual_network.vnet.address_space[0]
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.default_tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_snet_assoc" {
  for_each = local.subnets

  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.trainee_name_validated}-${local.name_suffix}-nic"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ip-config"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet["1"].id
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.default_tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${local.trainee_name_validated}-${local.name_suffix}-vm"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B2s"

  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${local.trainee_name_validated}-${local.name_suffix}-vm-os"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  admin_username = local.username
  admin_password = var.admin_password

  allow_extension_operations = false

  custom_data = filebase64("${path.module}/../scripts/cloud-init.sh")

  tags = local.default_tags
}

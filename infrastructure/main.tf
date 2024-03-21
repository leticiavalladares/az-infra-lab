resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = "rg-${local.name_suffix}"

  tags = local.default_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.name_suffix}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = local.default_tags
}

resource "azurerm_subnet" "snet" {
  name                 = "snet-${local.name_suffix}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.name_suffix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
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
  subnet_id                 = azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-vm-${local.name_suffix}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"

  tags = local.default_tags
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.name_suffix}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ip-config"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    subnet_id                     = azurerm_subnet.snet.id
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.default_tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${local.name_suffix}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B2s"

  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "os-vm-${local.name_suffix}"
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

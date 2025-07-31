resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
}

module "key_vault" {
  source              = "./modules/keyVault"
  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  ssh_public_key_path = var.ssh_public_key_path
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-${var.project_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1ms"
  admin_username      = var.admin_username
  network_interface_ids = [
    module.vnet.network_interface_id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = module.key_vault.ssh_public_key
  }

  os_disk {
    name                 = "disk-keycloak"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  disable_password_authentication = true

  lifecycle {
    prevent_destroy = true
  }
}
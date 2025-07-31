variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "project_name" {
  type = string
}

data "azurerm_client_config" "current" {}

#==================================================================================================
# Key Vault
#==================================================================================================
resource "azurerm_key_vault" "main" {
  name                      = "kv-${var.project_name}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  purge_protection_enabled  = false
  enable_rbac_authorization = true
  lifecycle {
    prevent_destroy = true
  }
}

#==================================================================================================
# Key Vault Secret for OpenVPN Server Admin User TLS Private Key
#==================================================================================================
resource "azurerm_key_vault_secret" "main_private_key" {
  name         = "${terraform.workspace}-${var.project_name}-ovpn-server-admin-user-private-key"
  value        = tls_private_key.ovpn.private_key_pem
  key_vault_id = azurerm_key_vault.main.id
}
#==================================================================================================
# Key Vault Secret for OpenVPN Server Admin User TLS Public Key
#==================================================================================================
resource "azurerm_key_vault_secret" "main_public_key" {
  name         = "${terraform.workspace}-${var.project_name}-ovpn-server-admin-user-public-key"
  value        = tls_private_key.ovpn.public_key_openssh
  key_vault_id = azurerm_key_vault.main.id
}

output "ssh_public_key" {
  description = "SSH public key stored as a secret in Key Vault"
  value       = azurerm_key_vault_secret.main_public_key.value
  sensitive   = true
}

output "ssh_private_key" {
  description = "SSH private key stored as a secret in Key Vault"
  value       = azurerm_key_vault_secret.main_private_key.value
  sensitive   = true
}
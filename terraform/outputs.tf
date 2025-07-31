output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = module.vnet.public_ip_address
}

output "private_key" {
  value = module.key_vault.ssh_private_key
  sensitive = true
}
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-keycloak-demo"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "project_name" {
  type = string
  default = "keycloak-demo"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Local path to SSH public key (to be stored in Key Vault)"
  type        = string
  default     = "~/.ssh/terraform_ansible.pub"
  sensitive   = true
}

variable "tags" {
  type = object({
    Environment = string
    CreatedBy   = string
  })
  default = {
    Environment = "Demo"
    CreatedBy   = "IaC/Terraform"
  }
}

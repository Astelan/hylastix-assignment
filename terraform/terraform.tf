terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }
  backend "azurerm" {
    subscription_id      = "0b9fa490-4a8a-4314-9797-024611c0a9d4"
    resource_group_name  = "rg-keycloak-demo"
    storage_account_name = "tfkeycloakbackend"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = "0b9fa490-4a8a-4314-9797-024611c0a9d4"
  features {}
}

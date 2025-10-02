terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1bc41998-e448-4a2c-b94a-731d3b7de5b1"
}

# Estado remoto de networks
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}
# Private DNS Zone para PostgreSQL
resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
}

# Link de la VNET a la zona
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "postgres-dns-link"
  resource_group_name   = data.terraform_remote_state.net.outputs.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = data.terraform_remote_state.net.outputs.vnet_id
}

# Servidor PostgreSQL Flexible (privado con subnet delegada y DNS zone)
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "mypg-flex2"
  resource_group_name    = data.terraform_remote_state.net.outputs.rg_name
  location               = data.terraform_remote_state.net.outputs.location
  version                = "13"
  administrator_login    = var.db_user
  administrator_password = var.db_pass

  storage_mb          = 32768
  sku_name            = "B_Standard_B1ms"

  delegated_subnet_id = data.terraform_remote_state.net.outputs.db_subnet
  private_dns_zone_id = azurerm_private_dns_zone.postgres_dns.id

  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [zone]
  }

  depends_on = [
    azurerm_private_dns_zone.postgres_dns,
    azurerm_private_dns_zone_virtual_network_link.postgres_dns_link
  ]
}

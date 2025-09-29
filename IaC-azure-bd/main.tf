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

# Servidor PostgreSQL Flexible (Privado)
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "mybd-test-rick-pss"
  resource_group_name    = data.terraform_remote_state.net.outputs.rg_name
  location               = data.terraform_remote_state.net.outputs.location
  version                = "13"
  administrator_login    = var.db_user
  administrator_password = var.db_pass

  storage_mb             = 32768
  sku_name               = "Standard_B1ms"

  # Desactivar acceso público
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [zone]
  }
}

# Private DNS Zone para PostgreSQL
resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
}

# Enlace entre la VNet y la zona DNS privada
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "postgres-dns-link"
  resource_group_name   = data.terraform_remote_state.net.outputs.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = data.terraform_remote_state.net.outputs.vnet_id
}

# Private Endpoint para PostgreSQL
resource "azurerm_private_endpoint" "db_private_endpoint" {
  name                = "pe-mypg-flex"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  subnet_id           = data.terraform_remote_state.net.outputs.db_subnet

  private_service_connection {
    name                           = "psc-mypg-flex"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

# Asociar el Private Endpoint con la zona DNS privada
resource "azurerm_private_dns_a_record" "postgres_private_record" {
  name                = azurerm_postgresql_flexible_server.db.name
  zone_name           = azurerm_private_dns_zone.postgres_dns.name
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.db_private_endpoint.private_service_connection[0].private_ip_address]
}

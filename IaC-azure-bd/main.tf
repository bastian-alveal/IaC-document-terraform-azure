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

# Importa solo lo necesario del proyecto de redes
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

# PostgreSQL Flexible Server con acceso público
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "mypg-flex"
  resource_group_name    = data.terraform_remote_state.net.outputs.rg_name
  location               = data.terraform_remote_state.net.outputs.location
  version                = "13"
  administrator_login    = var.db_user
  administrator_password = var.db_pass

  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"

  public_network_access_enabled = true
}

# Firewall: permite SOLO tu IP
resource "azurerm_postgresql_flexible_server_firewall_rule" "admin" {
  name             = "allow-admin"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = var.admin_ip
  end_ip_address   = var.admin_ip
}

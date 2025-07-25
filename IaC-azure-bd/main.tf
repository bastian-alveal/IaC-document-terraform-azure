# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "mypg-flex"
  resource_group_name    = data.terraform_remote_state.net.outputs.rg_name
  location               = data.terraform_remote_state.net.outputs.location
  version                = "13"
  delegated_subnet_id    = data.terraform_remote_state.net.outputs.db_subnet_id
  administrator_login    = var.db_user
  administrator_password = var.db_pass

  storage_mb             = 32768
  sku_name               = "Standard_B1ms"

  # Opcional: configuraciones adicionales
  # backup_retention_days  = 7
  # geo_redundant_backup_enabled = false

  # Usualmente, Network viene por defecto como privado al usar delegated_subnet_id
}

# Private Endpoint para acceso desde la VNet (Container App)
resource "azurerm_private_endpoint" "db_pe" {
  name                = "pe-db"
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  location            = data.terraform_remote_state.net.outputs.location
  subnet_id           = data.terraform_remote_state.net.outputs.db_subnet_id

  private_service_connection {
    name                           = "psc-db"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

# Firewall: permite SOLO tu IP para administración
resource "azurerm_postgresql_flexible_server_firewall_rule" "admin" {
  name             = "allow-admin"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = var.admin_ip
  end_ip_address   = var.admin_ip
}

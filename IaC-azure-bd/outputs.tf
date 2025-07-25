output "db_fqdn" {
  value       = azurerm_postgresql_flexible_server.db.fqdn
  description = "FQDN del servidor PostgreSQL"
}
output "db_user" {
  value = azurerm_postgresql_flexible_server.db.administrator_login
}
output "db_pass" {
  value = var.db_pass
  sensitive = true
}

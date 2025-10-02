output "db_fqdn" {
  value       = azurerm_postgresql_flexible_server.db.fqdn
  description = "FQDN privado de la base de datos"
}

output "db_user" {
  value       = azurerm_postgresql_flexible_server.db.administrator_login
  description = "Usuario administrador de la base de datos"
}

output "db_pass" {
  value       = var.db_pass
  description = "Password del admin (sensible)"
  sensitive   = true
}

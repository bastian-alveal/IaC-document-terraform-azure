# FQDN privado del PostgreSQL
output "db_private_fqdn" {
  value       = azurerm_postgresql_flexible_server.db.fqdn
  description = "FQDN privado del servidor PostgreSQL (resoluble en la VNet)"
}

output "db_user" {
  value       = azurerm_postgresql_flexible_server.db.administrator_login
  description = "Usuario administrador de la BD"
}

output "db_pass" {
  value       = var.db_pass
  description = "Password administrador de la BD"
  sensitive   = true
}

output "db_private_ip" {
  value       = azurerm_private_endpoint.db_private_endpoint.private_service_connection[0].private_ip_address
  description = "IP privada del Private Endpoint de la BD"
}

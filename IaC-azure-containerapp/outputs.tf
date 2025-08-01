# Outputs
output "containerapp_internal_fqdn" {
  value       = azurerm_container_app.backend.latest_revision_fqdn
  description = "FQDN interno del backend para acceso desde App Service"
}

output "containerapp_environment_id" {
  value       = azurerm_container_app_environment.ca_env.id
  description = "ID del Container App Environment"
}

output "containerapp_fqdn" {
  value       = azurerm_container_app.backend.latest_revision_fqdn
  description = "FQDN privado del backend para acceso interno desde App Service"
}

output "containerapp_environment_id" {
  value = azurerm_container_app_environment.ca_env.id
}

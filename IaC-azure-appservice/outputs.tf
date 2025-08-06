# Outputs
output "webapp_url" {
  value       = azurerm_linux_web_app.webapp.default_hostname
  description = "URL pública del App Service"
}

output "app_service_principal_id" {
  value       = azurerm_linux_web_app.webapp.identity[0].principal_id
  description = "Principal ID de la Managed Identity del App Service"
}

output "webapp_name" {
  value = azurerm_linux_web_app.webapp.name
}
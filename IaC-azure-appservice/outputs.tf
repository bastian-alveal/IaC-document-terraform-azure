# URL pública del App Service
output "webapp_url" {
  value       = azurerm_linux_web_app.webapp.default_hostname
  description = "URL pública del App Service"
}

# Backend FQDN que App Service usa
output "backend_url" {
  value       = data.terraform_remote_state.ca.outputs.containerapp_fqdn
  description = "URL del Container App (backend)"
}

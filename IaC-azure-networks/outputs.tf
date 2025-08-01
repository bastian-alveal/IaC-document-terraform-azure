# Nombre y ubicación del Resource Group
output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "Nombre del Resource Group principal"
}

output "location" {
  value       = azurerm_resource_group.rg.location
  description = "Ubicación de los recursos"
}

# VNet
output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Nombre de la VNet principal"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID de la VNet principal"
}

# Subnet para App Service
output "appservice_subnet" {
  value       = azurerm_subnet.appservice.id
  description = "ID de la subnet para App Service"
}

output "appservice_subnet_name" {
  value       = azurerm_subnet.appservice.name
  description = "Nombre de la subnet para App Service"
}

# Subnet para Container Apps
output "containerapp_subnet" {
  value       = azurerm_subnet.containerapp.id
  description = "ID de la subnet para Container Apps"
}

output "containerapp_subnet_name" {
  value       = azurerm_subnet.containerapp.name
  description = "Nombre de la subnet para Container Apps"
}

# Subnet para BD
output "db_subnet" {
  value       = azurerm_subnet.db.id
  description = "ID de la subnet para la base de datos (Private Endpoint)"
}

output "db_subnet_name" {
  value       = azurerm_subnet.db.name
  description = "Nombre de la subnet para la base de datos"
}

# Subnet para VM de administración
output "vm_admin_subnet" {
  value       = azurerm_subnet.vm_admin.id
  description = "ID de la subnet para la VM de administración"
}

output "vm_admin_subnet_name" {
  value       = azurerm_subnet.vm_admin.name
  description = "Nombre de la subnet para la VM de administración"
}

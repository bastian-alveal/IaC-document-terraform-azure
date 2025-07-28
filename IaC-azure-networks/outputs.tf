output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}


output "appservice_subnet" {
  value = azurerm_subnet.appservice.id
}
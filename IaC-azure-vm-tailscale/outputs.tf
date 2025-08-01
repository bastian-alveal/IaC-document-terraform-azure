# Outputs
output "vm_private_ip" {
  description = "IP privada de la VM Tailscale"
  value       = azurerm_network_interface.vm_nic.ip_configuration[0].private_ip_address
}

output "vm_admin_password" {
  description = "Contraseña del usuario administrador de la VM"
  value       = random_password.admin_password.result
  sensitive   = true
}

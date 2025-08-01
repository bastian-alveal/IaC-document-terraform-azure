# Outputs
output "vm_dbtest_private_ip" {
  value       = azurerm_network_interface.vm_dbtest_nic.ip_configuration[0].private_ip_address
  description = "IP privada de la VM de test BD"
}

output "vm_dbtest_admin_password" {
  value       = random_password.admin_password_dbtest.result
  description = "Password VM Test"
  sensitive   = true
}

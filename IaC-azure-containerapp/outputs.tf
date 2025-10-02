output "db_fqdn" {
  value = data.terraform_remote_state.db.outputs.db_fqdn
}

# Usuario administrador
output "db_user" {
  description = "Usuario administrador del servidor PostgreSQL"
  value       = data.terraform_remote_state.db.outputs.db_user
}

# Password administrador (sensible)
output "db_pass" {
  description = "Password administrador del servidor PostgreSQL"
  value       = data.terraform_remote_state.db.outputs.db_pass
  sensitive   = true
}

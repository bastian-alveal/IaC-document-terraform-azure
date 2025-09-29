variable "db_user" {
  type        = string
  description = "Usuario administrador de PostgreSQL Flexible"
}

variable "db_pass" {
  type        = string
  description = "Password del usuario administrador de PostgreSQL Flexible"
  sensitive   = true
}
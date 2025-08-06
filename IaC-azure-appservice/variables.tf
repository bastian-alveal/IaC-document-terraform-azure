# Variables
variable "ghcr_username" {
  type = string
}

variable "ghcr_pat" {
  type      = string
  sensitive = true
}

variable "appservice_name" {
  type        = string
  description = "Nombre del App Service"
}

variable "service_plan_name" {
  type        = string
  description = "Nombre del App Service Plan"
}
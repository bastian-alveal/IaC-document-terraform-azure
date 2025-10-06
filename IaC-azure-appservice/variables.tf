variable "ghcr_username" {
  type        = string
  description = "Usuario para autenticación en GHCR"
}

variable "ghcr_pat" {
  type        = string
  sensitive   = true
  description = "Token personal de acceso a GHCR"
}

variable "app_image" {
  type        = string
  description = "Imagen Docker para App Service"
}

variable "app_image_tag" {
  type        = string
  description = "Tag de la imagen Docker para App Service"
}

variable "appservice_name" {
  type        = string
  description = "Nombre del App Service"
}

variable "service_plan_name" {
  type        = string
  description = "Nombre del App Service Plan"
}
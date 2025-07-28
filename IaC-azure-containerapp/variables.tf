variable "ghcr_username" {
  type        = string
  description = "Usuario para GitHub Container Registry"
}

variable "ghcr_pat" {
  type        = string
  sensitive   = true
  description = "Token de acceso personal (PAT) para GHCR"
}

variable "container_image" {
  type        = string
  description = "Imagen de tu backend para Container App"
}

variable "container_image_tag" {
  type        = string
  description = "Tag de la imagen"
  default     = "latest"
}
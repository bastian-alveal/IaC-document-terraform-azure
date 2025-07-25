variable "container_image" {
  type        = string
  description = "Imagen de tu backend para Container App"
}

variable "container_image_tag" {
  type        = string
  description = "Tag de la imagen (opcional, según tu flujo)"
  default     = "latest"
}

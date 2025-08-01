variable "rg_name" {
  type        = string
  description = "Nombre del resource group"
}

variable "location" {
  type        = string
  description = "Ubicación de Azure"
}

variable "tailscale_authkey" {
  type      = string
  sensitive = true
}
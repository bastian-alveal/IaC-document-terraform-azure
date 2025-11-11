variable "rg_name" {
  description = "Nombre del Resource Group"
  type        = string
  default     = "rg-network-iac"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "eastus2"
}
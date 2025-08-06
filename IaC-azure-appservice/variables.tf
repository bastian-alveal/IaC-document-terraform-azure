variable "service_plan_name" {
  type = string
}

variable "appservice_name" {
  type = string
}

variable "ghcr_username" {
  type = string
}

variable "ghcr_pat" {
  type      = string
  sensitive = true
}
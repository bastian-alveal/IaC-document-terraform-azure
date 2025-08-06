terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0" # ya es 4.x compatible con application_stack.docker
    }
  }
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

provider "azurerm" {
  features {}
  subscription_id = "1bc41998-e448-4a2c-b94a-731d3b7de5b1"
}

data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

data "terraform_remote_state" "ca" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "containerapp.tfstate"
  }
}

# App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = var.service_plan_name
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# Web App
resource "azurerm_linux_web_app" "webapp" {
  name = "webapp-prod-${random_string.suffix.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {
    always_on = true

    application_stack {
      docker_image_name        = "ghcr.io/bastian-alveal/node-vite/vite-react:0.0.9"
      docker_registry_url      = "https://ghcr.io"
      docker_registry_username = var.ghcr_username
      docker_registry_password = var.ghcr_pat
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    BACKEND_URL                         = data.terraform_remote_state.ca.outputs.containerapp_internal_fqdn
  }

  identity {
    type = "SystemAssigned"
  }
}


# Integración App Service con VNet
resource "azurerm_app_service_virtual_network_swift_connection" "integration" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = data.terraform_remote_state.net.outputs.appservice_subnet
}

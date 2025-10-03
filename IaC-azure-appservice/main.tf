terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.102.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1bc41998-e448-4a2c-b94a-731d3b7de5b1"
}

# Estado remoto de red
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

# Estado remoto del container app (para obtener el backend FQDN)
data "terraform_remote_state" "ca" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "containerapp.tfstate"
  }
}

# Random para nombre único
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  os_type             = "Linux"
  #sku_name            = "P1v2"
  sku_name            = "B1"
}

# Web App con Docker (App Service)
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-${random_integer.ri.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  site_config {
    always_on = true

    application_stack {
      docker_image     = var.app_image
      docker_image_tag = var.app_image_tag
    }
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL          = "https://ghcr.io"
    DOCKER_REGISTRY_SERVER_USERNAME     = var.ghcr_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.ghcr_pat
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"

    # Variable para que el front sepa a dónde pegar
    BACKEND_URL = data.terraform_remote_state.ca.outputs.containerapp_fqdn
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image,
      site_config[0].application_stack[0].docker_image_tag
    ]
  }
}

# Integración App Service <-> VNet privada
resource "azurerm_app_service_virtual_network_swift_connection" "integration" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = data.terraform_remote_state.net.outputs.appservice_subnet
}

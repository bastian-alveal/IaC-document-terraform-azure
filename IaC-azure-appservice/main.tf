terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.107.0"
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

# ==========================================
# REMOTE STATES
# ==========================================
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

# ==========================================
# RANDOM NAME
# ==========================================
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# ==========================================
# SERVICE PLAN
# ==========================================
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${random_integer.ri.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# ==========================================
# LINUX WEB APP (Docker con GHCR)
# ==========================================
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-${random_integer.ri.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  site_config {
    always_on = true

    # ESTE ES EL FORMATO QUE ACEPTA AZURE HOY
    application_stack {
      docker_registry_url = "https://ghcr.io"
      docker_image_name   = "${var.app_image}:${var.app_image_tag}"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    BACKEND_URL = data.terraform_remote_state.ca.outputs.containerapp_fqdn

    # GHCR AUTH (FUNCIONA EN AZURERM 3.x)
    DOCKER_REGISTRY_SERVER_URL      = "https://ghcr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = var.ghcr_username
    DOCKER_REGISTRY_SERVER_PASSWORD = var.ghcr_pat
  }

  identity {
    type = "SystemAssigned"
  }
}

# ==========================================
# VNET INTEGRATION
# ==========================================
resource "azurerm_app_service_virtual_network_swift_connection" "integration" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = data.terraform_remote_state.net.outputs.appservice_subnet
}

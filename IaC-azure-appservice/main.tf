terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.11.0"
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
# RANDOM
# ==========================================
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# ==========================================
# SERVICE PLAN
# ==========================================
resource "azurerm_service_plan" "appserviceplan" {
  name                = "asp-${random_integer.ri.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name

  os_type  = "Linux"
  sku_name = "P1v3"
}

# ==========================================
# LINUX WEB APP (Docker GHCR PRIVATE IMAGE)
# ==========================================
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-${random_integer.ri.result}"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  https_only = true

  site_config {
    always_on = true

    application_stack {
      docker_image_name     = "${var.app_image}:${var.app_image_tag}"
      docker_registry_url   = "https://ghcr.io"
      docker_registry_username = var.ghcr_username
      docker_registry_password = var.ghcr_pat
    }
  }

  app_settings = {
    WEBSITES_PORT = "80"
  }
}

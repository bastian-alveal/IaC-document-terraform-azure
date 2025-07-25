data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

data "terraform_remote_state" "db" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "bd.tfstate"
  }
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.102.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Log Analytics (para monitoreo)
resource "azurerm_log_analytics_workspace" "la" {
  name                = "ca-logs"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container App Environment (en subnet privada)
resource "azurerm_container_app_environment" "ca_env" {
  name                       = "ca-env"
  location                   = data.terraform_remote_state.net.outputs.location
  resource_group_name        = data.terraform_remote_state.net.outputs.rg_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  vnet_configuration {
    infrastructure_subnet_id = data.terraform_remote_state.net.outputs.containerapp_subnet
  }
}

# Container App Backend
resource "azurerm_container_app" "backend" {
  name                         = "backend-containerapp"
  container_app_environment_id = azurerm_container_app_environment.ca_env.id
  resource_group_name          = data.terraform_remote_state.net.outputs.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      image  = "${var.container_image}:${var.container_image_tag}"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "DB_HOST"
        value = data.terraform_remote_state.db.outputs.db_fqdn
      }
      # Agrega otras variables de entorno necesarias
    }
    min_replicas = 1
    max_replicas = 2
  }

  ingress {
    external_enabled = false        # Solo acceso privado
    target_port      = 80           # Puerto del backend
  }

  lifecycle {
    # Terraform NO tocará la imagen si GitHub Actions la actualiza
    ignore_changes = [
      template[0].container[0].image
    ]
  }
}

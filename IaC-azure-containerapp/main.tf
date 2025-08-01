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
      version = "~> 4.37.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1bc41998-e448-4a2c-b94a-731d3b7de5b1"
}

# Log Analytics (para monitoreo)
resource "azurerm_log_analytics_workspace" "la" {
  name                = "ca-logs"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container App Environment con VNet Injection
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

  secret {
    name  = "ghcr-password"
    value = var.ghcr_pat
  }

  registry {
    server               = "ghcr.io"
    username             = var.ghcr_username
    password_secret_name = "ghcr-password"
  }

  template {
    container {
      name   = "backend"
      image  = "${var.container_image}:${var.container_image_tag}"
      cpu    = 0.5
      memory = "1Gi"

      }
      env {
        name  = "DB_HOST"
        value = data.terraform_remote_state.db.outputs.db_private_fqdn
      }
    }

    min_replicas = 1
    max_replicas = 2
  }

  ingress {
    external_enabled = false    # NO se expone públicamente
    internal_enabled = true     # Permite acceso interno desde la VNet
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image
    ]
  }
}


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

# Datos del state remoto de red
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

# Datos del state remoto de la BD
data "terraform_remote_state" "db" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "bd.tfstate"
  }
}

# Log Analytics
resource "azurerm_log_analytics_workspace" "la" {
  name                = "ca-logs"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container App Environment (usa subnet de containerapps, no delegada)
resource "azurerm_container_app_environment" "ca_env" {
  name                           = "ca-env"
  location                       = data.terraform_remote_state.net.outputs.location
  resource_group_name            = data.terraform_remote_state.net.outputs.rg_name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.la.id
  infrastructure_subnet_id       = data.terraform_remote_state.net.outputs.containerapp_subnet
  internal_load_balancer_enabled = true
}

# Container App Backend
resource "azurerm_container_app" "backend" {
  name                         = "backend-containerapp"
  container_app_environment_id = azurerm_container_app_environment.ca_env.id
  resource_group_name          = data.terraform_remote_state.net.outputs.rg_name
  revision_mode                = "Single"

  # secreto del GHCR
  secret {
    name  = "ghcr-password"
    value = var.ghcr_pat
  }

  # secreto de la BD
  secret {
    name  = "db-password"
    value = data.terraform_remote_state.db.outputs.db_pass
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

      env {
        name  = "DB_HOST"
        value = data.terraform_remote_state.db.outputs.db_fqdn
      }

      env {
        name  = "DB_USER"
        value = data.terraform_remote_state.db.outputs.db_user
      }

      env {
        name        = "DB_PASS"
        secret_name = "db-password"
      }
    }

    min_replicas = 1
    max_replicas = 2
  }

  ingress {
    external_enabled = false
    target_port      = 80
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image
    ]
  }
}

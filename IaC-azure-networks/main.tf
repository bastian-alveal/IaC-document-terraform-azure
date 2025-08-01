terraform {
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

# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# Red principal
resource "azurerm_virtual_network" "vnet" {
  name                = "main-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

# Subnet para App Service (delegada)
resource "azurerm_subnet" "appservice" {
  name                 = "snet-appservice"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]

  delegation {
    name = "delegation-appservice"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Subnet para Container Apps (delegada)
resource "azurerm_subnet" "containerapp" {
  name                 = "snet-containerapp"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.2.0/24"]

  delegation {
    name = "delegation-containerapp"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Subnet para BD (con private endpoint)
resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.3.0/24"]
}

# Subnet para VM de administración (Tailscale)
resource "azurerm_subnet" "vm_admin" {
  name                 = "snet-vm-admin"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.4.0/24"]
}

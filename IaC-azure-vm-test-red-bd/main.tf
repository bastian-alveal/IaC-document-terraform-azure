terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
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

# Estado remoto de la red
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

# Generar contraseña aleatoria para el admin
resource "random_password" "admin_password_dbtest" {
  length  = 16
  special = true
}

# NIC de la VM de Test
resource "azurerm_network_interface" "vm_dbtest_nic" {
  name                = "vm-dbtest-nic"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = data.terraform_remote_state.net.outputs.db_subnet
    private_ip_address_allocation = "Dynamic"
  }
}

# VM de Test
resource "azurerm_linux_virtual_machine" "vm_dbtest" {
  name                = "vm-dbtest"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  network_interface_ids = [azurerm_network_interface.vm_dbtest_nic.id]
  size                = "Standard_B1s"

  admin_username      = "azureuser"
  admin_password      = random_password.admin_password_dbtest.result
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Cloud-init básico
  custom_data = base64encode(file("cloud-init-basic.yaml"))
}


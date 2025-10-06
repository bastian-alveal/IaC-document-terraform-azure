terraform {
  required_version = ">= 1.5.0"

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

# ======================================================
# 🔹 Estado remoto de la red (infra base)
# ======================================================
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "networks.tfstate"
  }
}

# ======================================================
# 🔹 Genera una contraseña aleatoria para el usuario admin
# ======================================================
resource "random_password" "admin_password" {
  length  = 16
  special = true
}

# ======================================================
# 🔹 Interfaz de red (NIC)
# ======================================================
resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-tailscale-nic"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = data.terraform_remote_state.net.outputs.vm_admin_subnet
    private_ip_address_allocation = "Dynamic"
  }
}

# ======================================================
# 🔹 Máquina Virtual Linux (Ubuntu 22.04 LTS)
# ======================================================
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-tailscale"
  location            = data.terraform_remote_state.net.outputs.location
  resource_group_name = data.terraform_remote_state.net.outputs.rg_name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                = "Standard_B1s"

  admin_username                   = "azureuser"
  admin_password                   = random_password.admin_password.result
  disable_password_authentication  = false

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

  # Cloud-init para configurar Tailscale en el arranque
  custom_data = base64encode(
    templatefile("${path.module}/cloud-init.yaml.tpl", {
      tailscale_authkey = var.tailscale_authkey
    })
  )
}


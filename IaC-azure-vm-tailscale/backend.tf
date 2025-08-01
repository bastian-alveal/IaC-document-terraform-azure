terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatebastian01"
    container_name       = "tfstate"
    key                  = "vm-admin.tfstate"  # Puedes usar un key diferente por proyecto o ambiente
  }
}

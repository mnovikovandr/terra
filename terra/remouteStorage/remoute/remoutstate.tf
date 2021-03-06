provider "azurerm" {
  features {}
 msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

data "azurerm_resource_group" "ymngroup" {
    name = "ymngroup"
}

terraform {
    backend "azurerm" {
        storage_account_name = "ymnstoreaccount"
        container_name = "storecontainer"
        key = "remoute.terraform.tfstage"
    }
}

resource "azurerm_resource_group" "ymngroupnewtest" {
  name     = "ymngroupnew"
  location = "West Europe"
}
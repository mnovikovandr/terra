terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"  
   }
  }
}

provider "azurerm" {
  features {}
 msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

resource "azurerm_storage_account" "misha87account" {
  name                     = "misha87account"
  resource_group_name      = "cloud-shell-storage-westeurope"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    storage = "test"
  }
}

resource "azurerm_storage_container" "csb100320010eec47c0" {
  name                  = "storagecontainer"
  storage_account_name  = "cloud-shell-storage-westeurope"
  container_access_type = "private"
}

data "azurerm_resource_group" "storagegrouptest" {
    name = "storagegrouptest"
}

terraform {
    backend "azurerm" {
        storage_account_name = "misha87account"
        container_name = "storagecontainer"
        key = "terraform.tfstage"
    }
}
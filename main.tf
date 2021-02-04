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

resource "azurerm_resource_group" "storagegroup" {
  name     = "storagegroup"
  location = "West Europe"
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "examplestoraccount"
  resource_group_name      = azurerm_resource_group.storagegroup.name
  location                 = azurerm_resource_group.storagegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "stcontainer" {
  name                  = "con"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}
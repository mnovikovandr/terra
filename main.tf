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

resource "azurerm_resource_group" "mygroup" {
  name     = "mygroup"
  location = "West Europe"
}

resource "azurerm_storage_account" "store" {
  name = "mystore"
  resource_group_name = "${azure_resource_group.mygroup.name}"
  location = "${azure_resource_group.mygroup.location}"
  account_tier = "Standart"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "mycontainer" {
  name = "terraformtest"
  resource_group_name = "${azure_resource_group.mygroup.name}"
  resource_account_name = "${azure_storage_account.store.name}"
}
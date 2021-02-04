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

resource "azurerm_resource_group" "example" {
  name     = "mygroup"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name = "mystore"
  resource_group_name = "${azure_resource_group.example.name}"
  location = "${azure_resource_group.example.location}"
  account_tier = "Standart"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name = "terraformtest"
  storage_account_name = "${azurerm_storage_account.example.name}"
  container_access_type = "private"
}
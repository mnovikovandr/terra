provider "azurerm" {
  features {}
 msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

resource "azurerm_resource_group" "example" {
  name     = "mygroup"
  location = "West Europe"
}

data "azurerm_resource_group" "storagegroup" {
    name = "storagegroup"
}

terraform {
    backend "azurerm" {
        storage_account_name = "examples1t1o1raccount"
        container_name = "con"
        key = "Data.terraform.tfstage"
    }
}
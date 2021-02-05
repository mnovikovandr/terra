data "azurerm_resource_group" "storagegroup" {
    name = "storagegroup"
    features {}
}

terraform {
    backend "azurerm" {
        storage_account_name = "examples1t1o1raccount"
        container_name = "con"
        key = "Data.terraform.tfstage"
    }
}
data "azurerm_resource_group" "example" {
    name = "arg"
}

resource "azurerm_managed_disk" "example" {
    name = "managed_disk_name"
    location = "West Europe"
    resource_group_name = "arg"
    storage_account_type = "Standart_LRS"
    create_option = "Empty"
    disc_size_gb = "1"
}

terraform {
    backend "azurerm" {
        storage_account_name = "tfsorrrandomwname"
        container_name = "con"
        key = "Data.terraform.tfstage"
    }
}
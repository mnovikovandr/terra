data "azurerm_resource_group" "example" {
    name = "arg"
}

resource "azurerm_managed_disk" "example" {
    name = "managed_disk_name"
    location
}
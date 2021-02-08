resource "azurerm_resource_group" "example" {
    name = "exampleGroup"
    location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
    name = "virtualNetwork"
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
    resource_group_name = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefix = "10.0.1.0/24"
}
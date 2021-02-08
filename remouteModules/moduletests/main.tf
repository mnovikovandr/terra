resource "azurerm_resource_group" "example" {
    name = var.resource_group
    location = location
}

resource "azurerm_virtual_network" "example" {
    name = vnet
    location = var.azurerm_resource_group.example.location
    resource_group_name = var.azurerm_resource_group.example.name
    address_space = [address_space]
}

resource "azurerm_subnet" "subnet" {
    name = subnet_name
    virtual_network_name = var.azurerm_virtual_network.example.name
    resource_group_name = var.azurerm_resource_group.example.name
    address_prefixes = subnet_prefix
}
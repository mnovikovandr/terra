resource "azurerm_resource_group" "novikovTerraformGroup"  {
    name = "novikovTerraformGroup"
    location = "westeurope"
}

resource "azurerm_virtual_network" "novikovTerraformGroupNetwork" {
    name = "novikovVirtualNet"
    location = azurerm_resource_group.novikovterraformgroup.location
    resource_group_name = azurerm_resource_group.novikovterraformgroup.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "novikovTerraformnSubNet" {
    name = "novikovTerraformnSubNet"
    virtual_network_name = azurerm_virtual_network.novikovTerraformGroupNetwork.name
    resource_group_name = azurerm_resource_group.novikovterraformgroup.name
    address_prefixes = ["10.0.1.0/24"]
}
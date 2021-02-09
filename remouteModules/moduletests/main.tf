provider "azurerm" {
   features {}
   msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

resource "azurerm_resource_group" "novikovTerraformGroup"  {
    name = "novikovTerraformGroup"
    location = "westeurope"
}

resource "azurerm_virtual_network" "novikovTerraformGroupNetwork" {
    name = "novikovVirtualNet"
    location = azurerm_resource_group.novikovTerraformGroup.location
    resource_group_name = azurerm_resource_group.novikovTerraformGroup.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "novikovTerraformnSubNet" {
    name = "novikovTerraformnSubNet"
    virtual_network_name = azurerm_virtual_network.novikovTerraformGroupNetwork.name
    resource_group_name = azurerm_resource_group.novikovTerraformGroup.name
    address_prefixes = ["10.0.1.0/24"]
}
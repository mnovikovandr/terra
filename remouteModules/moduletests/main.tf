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
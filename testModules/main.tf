module "moduletests" {
    source = "github.com/hashicorp/example"
}

resource "azurerm_resource_group" "res" {
  name     = "groupAfterModuleChange"
  location = "West Europe"
}
module "moduletests" {
    source = "github.com/mnovikovandr/terra/remouteModules/moduletests"
}

resource "azurerm_resource_group" "res" {
  name     = "groupAfterModuleChange"
  location = "West Europe"
}
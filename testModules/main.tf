module "moduletests" {
    source = "github.com/mnovikovandr/terra/remouteModules/moduletests"
}

resource "azurerm_resource_group" "storagegroup" {
  name     = "storagegroup"
  location = "West Europe"
}

provider "azurerm" {
   features {}
   msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}
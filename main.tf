provider "azurerm" {    
    version = "2.45.1"
    features {}
     msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}
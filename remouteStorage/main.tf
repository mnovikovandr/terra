terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"  
   }
  }
}

provider "azurerm" {
  features {}
 msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

resource "azurerm_storage_container" "csb100320010eec47c0" {
  name                  = "storagecontainer"
  storage_account_name  = "cloud-shell-storage-westeurope"
  container_access_type = "private"
}

terraform {
    backend "azurerm" {
        storage_account_name = "csb100320010eec47c0"
        container_name = "storagecontainer"
        key = "terraform.tfstage"
    }
}
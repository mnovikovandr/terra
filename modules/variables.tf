provider "azurerm" {
   features {}
   msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

variable "resource_group" {
    default = "testmodulegroup"
}

variable "location" {
    default = "West Europe"
}

variable "vnet" {
    default = "modulevnet"
}

variable "address_space" {
    default = "10.0.0.0/16"
}
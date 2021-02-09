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

resource "azurerm_public_ip" "novikovTerraformPublicIp" {
    name                         = "novikovPublicIP"
    location                     = azurerm_resource_group.novikovTerraformGroup.location
    resource_group_name          = azurerm_resource_group.novikovTerraformGroup.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "novikovTerraformSecurityGroup" {
    name                = "novikovTerraformSecurityGroup"
    location            = azurerm_resource_group.novikovTerraformGroup.location
    resource_group_name = azurerm_resource_group.novikovTerraformGroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "novikovTerraformNetworkInterface" {
    name                      = "novikovTerraformNetworkInterface"
    location                  = azurerm_resource_group.novikovTerraformGroup.location
    resource_group_name       = azurerm_resource_group.novikovTerraformGroup.name

    ip_configuration {
        name                          = "novikovNicConfiguration"
        subnet_id                     = azurerm_subnet.novikovTerraformnSubNet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip. novikovTerraformPublicIp.id
    }
}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.novikovTerraformNetworkInterface.id
    network_security_group_id = azurerm_network_security_group.novikovTerraformSecurityGroup.id
}

resource "random_id" "randomId" {
    keepers = {
        resource_group = azurerm_resource_group.novikovTerraformGroup.name
    }
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.novikovTerraformGroup.name
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}
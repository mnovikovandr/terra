module "moduletests" {
    source = "github.com/mnovikovandr/terra/remouteModules/moduletests"
}

resource "azurerm_subnet" "novikovTerraformnSubNet" {
    name = "novikovTerraformnSubNet"
    virtual_network_name = "novikovTerraformGroupNetwork"
    resource_group_name = "novikovTerraformGroup"
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "novikovTerraformPublicIp" {
    name                         = "novikovPublicIP"
    location                     = "westeurope"
    resource_group_name          = "novikovTerraformGroup"
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "novikovTerraformSecurityGroup" {
    name                = "novikovTerraformSecurityGroup"
    location            = "westeurope"
    resource_group_name = "novikovTerraformGroup"

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
    location                  = "westeurope"
    resource_group_name       = "novikovTerraformGroup"

    ip_configuration {
        name                          = "novikovNicConfiguration"
        subnet_id                     = azurerm_subnet.novikovTerraformnSubNet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.novikovTerraformPublicIp.id
    }
}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.novikovTerraformNetworkInterface.id
    network_security_group_id = azurerm_network_security_group.novikovTerraformSecurityGroup.id
}

resource "random_id" "randomId" {
    keepers = {
        resource_group = "novikovTerraformGroup"
    }
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "mystorageaccount"
    resource_group_name         = "novikovTerraformGroup"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "tls_private_key" "tf_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = tls_private_key.tf_ssh.private_key_pem }

resource "azurerm_linux_virtual_machine" "terraVM" {
    name                  = "terraVM"
    location              = "westeurope"
    resource_group_name   = "novikovTerraformGroup"
    network_interface_ids = [azurerm_network_interface.novikovTerraformNetworkInterface.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "novikov"
    admin_username = "azureuser"
    disable_password_authentication = true
}
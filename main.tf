
provider "azurerm" {
    version = "~>2.0"
    features {}
     msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

resource "azurerm_resource_group" "novikovterraformgroup" {
    name     = "novikovResourceGroup"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "novikovterraformnetwork" {
    name                = "novikovVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.novikovterraformgroup.name

    tags = {
        environment = "Terraform Demo"
    }
}


# Create subnet
resource "azurerm_subnet" "novikovterraformsubnet" {
    name                 = "novikovSubnet"
    resource_group_name  = azurerm_resource_group.novikovterraformgroup.name
    virtual_network_name = azurerm_virtual_network.novikovterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "novikovterraformpublicip" {
    name                         = "novikovPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.novikovterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "novikovterraformnsg" {
    name                = "novikovNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.novikovterraformgroup.name

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

    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "novikovterraformnic" {
    name                      = "novikovNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.novikovterraformgroup.name

    ip_configuration {
        name                          = "novikovNicConfiguration"
        subnet_id                     = azurerm_subnet.novikovterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip. novikovterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.novikovterraformnic.id
    network_security_group_id = azurerm_network_security_group.novikovterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group. novikovterraformgroup.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.novikovterraformgroup.name
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "tf_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = tls_private_key.tf_ssh.private_key_pem }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "novikovterraformvm" {
    name                  = "novikovVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.novikovterraformgroup.name
    network_interface_ids = [azurerm_network_interface.novikovterraformnic.id]
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

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.tf_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}

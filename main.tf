# Configure the Microsoft Azure Provider
provider "azurerm" {
      version = "~>2.0"
    features {}
     msi_endpoint = "http://169.254.169.254/metadata/identity/oauth2/token"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "terraformgroup" {
    name     = "shabunevichResourceGroup"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "shabunevichterraformnetwork" {
    name                = "shabunevichVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.terraformgroup.name

    tags = {
        environment = "Terraform Demo"
    }
}


# Create subnet
resource "azurerm_subnet" "shabunevichterraformsubnet" {
    name                 = "shabunevichSubnet"
    resource_group_name  = azurerm_resource_group.terraformgroup.name
    virtual_network_name = azurerm_virtual_network.shabunevichterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "shabunevichterraformpublicip" {
    name                         = "shabunevichPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.terraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "shabunevichterraformnsg" {
    name                = "shabunevichNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.terraformgroup.name

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
resource "azurerm_network_interface" "shabunevichterraformnic" {
    name                      = "shabunevichNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.terraformgroup.name

    ip_configuration {
        name                          = "shabunevichNicConfiguration"
        subnet_id                     = azurerm_subnet.shabunevichterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip. shabunevichterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.shabunevichterraformnic.id
    network_security_group_id = azurerm_network_security_group.shabunevichterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group. terraformgroup.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.terraformgroup.name
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
resource "azurerm_linux_virtual_machine" "shabunevichterraformvm" {
    name                  = "shabunevichVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.terraformgroup.name
    network_interface_ids = [azurerm_network_interface.shabunevichterraformnic.id]
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

    computer_name  = "shabunevichvm"
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

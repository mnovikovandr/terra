module "moduletests" {
    source = "github.com/mnovikovandr/terra/remouteModules/moduletests"
}

resource "azurerm_linux_virtual_machine" "terraVM" {
    name                  = "terraVM"
    location              = "westeurope"
    resource_group_name   = novikovTerraformGroup
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

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.tf_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }
}
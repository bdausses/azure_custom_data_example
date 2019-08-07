locals {
  virtual_machine_name = "testbox"
}

# Render the template for CustomData.bin
data "template_file" "CustomData" {
  template = "${file("${path.root}/files/bootstrap.ps1.tpl")}"
  vars = {
    chef_server_url         = "${var.chef_server_url}"
    validation_client_name  = "${var.validation_client_name}"
    validator_key           = "${file("${var.validator_key_file}")}"
  }
}

# Create the VM
resource "azurerm_virtual_machine" "client" {
  name                          = "${local.virtual_machine_name}"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.primary.id}"]
  vm_size                       = "Standard_F4"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.virtual_machine_name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

# CustomData.bin is populated with the custom_data directive here
  os_profile {
    computer_name  = "${local.virtual_machine_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data = "${data.template_file.CustomData.rendered}"
  }

# Ensure we're enabling the VM agent
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

# Execute powershell with the VM agent to bootstrap the box (from the CustomData.bin file)
resource "azurerm_virtual_machine_extension" "script" {
  depends_on           = ["azurerm_virtual_machine.client"]
  name                 = "CustomScriptExtension"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${local.virtual_machine_name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.4"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command copy-item \"c:\\AzureData\\CustomData.bin\" \"c:\\AzureData\\bootstrap.ps1\";\"c:\\AzureData\\bootstrap.ps1\""
    }
SETTINGS
}

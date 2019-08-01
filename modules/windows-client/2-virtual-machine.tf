locals {
  virtual_machine_name = "testbox"
}

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

  os_profile {
    computer_name  = "${local.virtual_machine_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data = <<BOOTSTRAP_SCRIPT
    
      ## Download the Chef Client
      $clientURL = "https://packages.chef.io/files/stable/chef/15.1.36/windows/2016/chef-client-15.1.36-1-x64.msi"
      $clientDestination = "C:\chef-client.msi"
      Invoke-WebRequest $clientURL -OutFile $clientDestination

      ## Install the Chef Client
      Start-Process msiexec.exe -ArgumentList @('/qn', '/lv C:\Windows\Temp\chef-log.txt', '/i C:\chef-client.msi', 'ADDLOCAL="ChefClientFeature,ChefSchTaskFeature,ChefPSModuleFeature"') -Wait

      ## At this point, the chef-client is installed and ready for use.  

      ## Once the client is installed, you would do more stuff here, like setting up first-boot.json and client.rb...  then execute the initial chef-client run.
      ## See the example here:  https://docs.chef.io/install_bootstrap.html#powershell-user-data

    BOOTSTRAP_SCRIPT
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

resource "azurerm_virtual_machine_extension" "script" {
  name                 = "CustomScriptExtension"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${local.virtual_machine_name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.4"
  depends_on           = ["azurerm_virtual_machine.client"]

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command copy-item \"c:\\AzureData\\CustomData.bin\" \"c:\\AzureData\\bootstrap.ps1\";\"c:\\AzureData\\bootstrap.ps1\""
    }
SETTINGS
}
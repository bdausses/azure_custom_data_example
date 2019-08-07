provider "azurerm" {
}

locals {
  resource_group_name = "${var.prefix}-resources"
}

resource "azurerm_resource_group" "test" {
  name     = "${local.resource_group_name}"
  location = "Central US"
}

module "network" {
  source              = "./modules/network"
  prefix              = "${var.prefix}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${azurerm_resource_group.test.location}"
}

module "windows-client" {
  source                    = "./modules/windows-client"
  resource_group_name       = "${azurerm_resource_group.test.name}"
  location                  = "${azurerm_resource_group.test.location}"
  prefix                    = "${var.prefix}"
  subnet_id                 = "${module.network.domain_clients_subnet_id}"
  admin_username            = "${var.admin_username}"
  admin_password            = "${var.admin_password}"
  chef_server_url           = "${var.chef_server_url}"
  validation_client_name    = "${var.validation_client_name}"
  validator_key_file        = "${var.validator_key_file}"
}

output "windows_client_public_ip" {
  value = "${module.windows-client.public_ip_address}"
}

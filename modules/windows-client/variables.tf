variable "resource_group_name" {
  description = "The name of the Resource Group where the Windows Client resources will be created"
}

variable "location" {
  description = "The Azure Region in which the Resource Group exists"
}

variable "prefix" {
  description = "The Prefix used for the Windows Client resources"
}

variable "subnet_id" {
  description = "The Subnet ID which the Windows Client's NIC should be created in"
}

variable "admin_username" {
  description = "The username associated with the local administrator account on the virtual machine"
}

variable "admin_password" {
  description = "The password associated with the local administrator account on the virtual machine"
}

variable "chef_server_url" {
  description = "The full URL to your Chef server"
  default     = "https://my_chef_server.domain.com/organizations/my_org/"
}

variable "validation_client_name" {
  description = "The name of the validation client on your Chef server"
}

variable "validator_key_file" {
  description = "The path to the local copy of your validator key file"
}

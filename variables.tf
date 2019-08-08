variable "prefix" {
  description = "The prefix used for all resources in this example. Needs to be a short (6 characters) alphanumeric string. Example: `myprefix`."
}

variable "admin_username" {
  description = "The username of the administrator account for both the local accounts, and Active Directory accounts. Example: `myexampleadmin`"
}

variable "admin_password" {
  description = "The password of the administrator account for both the local accounts, and Active Directory accounts. Needs to comply with the Windows Password Policy. Example: `PassW0rd1234!`"
}

variable "chef_server_url" {
  description = "The full URL to your Chef server"
}

variable "validation_client_name" {
  description = "The name of the validation client on your Chef server"
}

variable "validator_key_file" {
  description = "The path to the local copy of your validator key file"
}

variable "run_list" {
  description = "Run list for the node"
  type = "list"
    default = [
      "recipe[chef-client::default]"
    ]
}

# Azure Custom Data Example
This repo contains terraform code that will spin up a Win2k16 VM in Azure, then execute a powershell script that is passed in via custom data at provisioning time.

**DISCLAIMER**:  This code is for example use only.  Do your due dilligence and inspect it if you plan to use any of it for anything other than experimentation.

## Usage
- Copy terraform.tfvars.example to terraform.tfvars.
  - `cp terraform.tfvars.example terraform.tfvars`
- Edit terraform.tfvars and use whatever values you need.
  - `vi terraform.tfvars`
- Initialize and apply the plan.
  - `terraform init`
  - `terraform apply`

## Credit
Some ideas, code, and inspiration taken from:
https://github.com/terraform-providers/terraform-provider-azurerm

## License
This is licensed under [the Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0).
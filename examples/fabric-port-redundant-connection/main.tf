# Configure the Equinix Provider
# Please refer to provider documentation for details on supported authentication methods and parameters.
# https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
}

# Configure the Microsoft Azure Provider
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure
provider "azurerm" {
  features {}
}

module "equinix-fabric-connection-azure" {
  source = "equinix-labs/fabric-connection-azure/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_port_name = var.primary_port_name
  fabric_vlan_stag = 1510

  fabric_secondary_port_name = var.secondary_port_name
  fabric_secondary_vlan_stag = 1520

  az_region = "UK South" // required if create_resource_group is true
}

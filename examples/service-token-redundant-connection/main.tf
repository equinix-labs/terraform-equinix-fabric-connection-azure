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
  fabric_service_token_id           = var.fabric_service_token_id
  fabric_secondary_service_token_id = var.fabric_secondary_service_token_id

  fabric_speed = 100

  az_region                = "West US" // corresponds to Silicon Valley
  az_create_resource_group = false
  az_resource_group_name   = var.existing_resource_group_name
}

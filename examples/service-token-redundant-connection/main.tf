provider "equinix" {}

provider "azurerm" {
  features {}
}

module "equinix-fabric-connection-azure" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-azure"
  
  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_service_token_id           = var.fabric_service_token_id
  fabric_secondary_service_token_id = var.fabric_secondary_service_token_id

  fabric_speed = 100

  az_create_resource_group = false
  az_resource_group_name   = var.existing_resource_group_name
}

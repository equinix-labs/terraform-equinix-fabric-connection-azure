provider "equinix" {}

provider "azurerm" {
  features {}
}

variable "fabric_service_token_id" {}
variable "fabric_secondary_service_token_id" {}
variable "existing_resource_group_name" {}

module "equinix-fabric-connection-azure" {
  # source = "github.com/equinix-labs/terraform-equinix-fabric-connection-azure"
  source = "../../"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_service_token_id           = var.fabric_service_token_id
  fabric_secondary_service_token_id = var.fabric_secondary_service_token_id

  fabric_destination_metro_code = "FR"
  fabric_speed                  = 100

  az_create_resource_group         = false
  az_resource_group_name           = var.existing_resource_group_name
  az_region                        = "Germany West Central"
  az_expressroute_peering_location = "Frankfurt2"
}

output "connection_details" {
  value = module.equinix-fabric-connection-azure
}

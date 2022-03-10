provider "equinix" {}

provider "azurerm" {
  features {}
}

variable "port_name" {}

module "equinix-fabric-connection-azure" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-azure"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_port_name                 = var.port_name
  fabric_vlan_stag                 = 1010
  fabric_destination_metro_code    = "FR"
  fabric_speed                     = 100
  fabric_secondary_vlan_stag       = 1020
  az_region                        = "Germany West Central"
  az_expressroute_peering_location = "Frankfurt2"
}

output "connection_details" {
  value = module.equinix-fabric-connection-azure
}

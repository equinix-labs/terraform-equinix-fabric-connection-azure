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
  fabric_port_name           = var.port_name
  fabric_vlan_stag           = 1010
  fabric_secondary_vlan_stag = 1020
  
  fabric_destination_metro_code = "LD"
  fabric_speed                  = 100

  az_region                        = "UK South"
  az_expressroute_peering_location = "London"
}

output "connection_details" {
  value = module.equinix-fabric-connection-azure
}

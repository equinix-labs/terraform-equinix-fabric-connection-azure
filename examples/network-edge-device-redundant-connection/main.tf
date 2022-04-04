provider "equinix" {}

provider "azurerm" {
  features {}
}

module "equinix-fabric-connection-azure" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-azure"
  
  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  network_edge_device_id           = var.primary_device_id
  network_edge_secondary_device_id = var.secondary_device_id
  network_edge_configure_bgp       = true

  fabric_speed = 200

  az_resource_group_name = "rg-exproute" // will create a new resource group
  az_region              = "West US 3" // corresponds to Los Angeles

  az_exproute_peering_customer_asn      = 65432 // overrides default value
  az_exproute_peering_primary_address   = "169.0.0.0/30" // overrides default value
  az_exproute_peering_secondary_address = "169.0.0.4/30" // overrides default value
  az_exproute_peering_shared_key        = "BGPSecretKey!" // optionally set a shared key, special characters are not supported
}

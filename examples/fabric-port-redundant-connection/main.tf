provider "equinix" {}

provider "azurerm" {
  features {}
}

module "equinix-fabric-connection-azure" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-azure"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_port_name = var.primary_port_name
  fabric_vlan_stag = 1510

  fabric_secondary_port_name = var.secondary_port_name
  fabric_secondary_vlan_stag = 1520

  az_region = "UK South" // corresponds to London
}

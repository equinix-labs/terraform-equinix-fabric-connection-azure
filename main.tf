locals {
  az_resource_group_name = coalesce(var.az_resource_group_name, lower(format("rg-%s", random_string.this.result)))
  az_resource_group_id   = var.az_create_resource_group ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.this[0].id
}

data "azurerm_resource_group" "this" {
  count = var.az_create_resource_group? 0 : 1

  name = local.az_resource_group_name
}

resource "azurerm_resource_group" "this" {
  count = var.az_create_resource_group? 1 : 0

  name     = local.az_resource_group_name
  location = var.az_region
  tags     = var.az_tags
}

resource "azurerm_express_route_circuit" "this" {
  name                  = coalesce(var.az_express_route_circuit_name, lower(format("xr-circuit-%s", random_string.this.result)))
  resource_group_name   = local.az_resource_group_name
  location              = var.az_create_resource_group ? azurerm_resource_group.this[0].location : data.azurerm_resource_group.this[0].location
  service_provider_name = "Equinix"
  peering_location      = var.az_expressroute_peering_location
  bandwidth_in_mbps     = var.fabric_speed_unit == "MB" ? var.fabric_speed : null
  bandwidth_in_gbps     = var.fabric_speed_unit == "GB" ? var.fabric_speed : null
  express_route_port_id = var.fabric_speed_unit == "GB" ? var.az_expressroute_port_id : null
  
  sku {
    tier   = var.az_expressroute_sku.tier
    family = var.az_expressroute_sku.family
  }
  
  tags = var.az_tags
}

resource "random_string" "this" {
  length  = 3
  special = false
}

module "equinix-fabric-connection" {
  # source = "github.com/equinix-labs/terraform-equinix-fabric-connection"
  source = "../terraform-equinix-fabric-connection"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name                      = var.fabric_connection_name
  seller_profile_name       = "Azure ExpressRoute"
  seller_metro_code         = var.fabric_destination_metro_code
  seller_metro_name         = var.fabric_destination_metro_name
  seller_authorization_key  = azurerm_express_route_circuit.this.service_key
  named_tag                 = var.az_named_tag
  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  speed_unit                = var.fabric_speed_unit
  purcharse_order_number    = var.fabric_purcharse_order_number
  zside_vlan_ctag           = var.fabric_zside_vlan_ctag

  redundancy_type     = "Redundant"
  secondary_name      = var.fabric_secondary_connection_name
  secondary_port_name = var.fabric_secondary_port_name
  secondary_vlan_stag = var.fabric_secondary_vlan_stag
}

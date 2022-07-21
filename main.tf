locals {
  az_resource_group_name = coalesce(var.az_resource_group_name, lower(format("rg-%s", random_string.this.result)))
  az_location            = var.az_create_resource_group ? azurerm_resource_group.this[0].location : data.azurerm_resource_group.this[0].location
  az_exproute_location   = coalesce(var.az_exproute_location, local.az_location)
  az_exproute_regions    = csvdecode(file("${path.module}/REGIONS.csv"))

  az_exproute_peering_location = coalesce(var.az_exproute_equinix_peering_location, one([
    for region in local.az_exproute_regions: region.peering_location
    if region.cli_location == local.az_location
  ]))

  az_exproute_peering_types  = {
    "PRIVATE"   = "AzurePrivatePeering",
    "MICROSOFT" = "MicrosoftPeering"
  }
  
  fabric_seller_metro_code = coalesce(var.fabric_destination_metro_code, one([
    for region in local.az_exproute_regions: region.metro_code
    if region.cli_location == local.az_location
  ]))
}

data "azurerm_resource_group" "this" {
  count = var.az_create_resource_group ? 0 : 1

  name = local.az_resource_group_name
}

resource "azurerm_resource_group" "this" {
  count = var.az_create_resource_group ? 1 : 0

  name     = local.az_resource_group_name
  location = var.az_region
  tags     = var.az_tags
}

resource "random_string" "this" {
  length  = 3
  special = false
}

resource "azurerm_express_route_circuit" "this" {
  name                  = coalesce(var.az_exproute_circuit_name, lower(format("xr-circuit-%s", random_string.this.result)))
  resource_group_name   = local.az_resource_group_name
  location              = local.az_location
  service_provider_name = "Equinix"
  peering_location      = local.az_exproute_peering_location 
  bandwidth_in_mbps     = var.fabric_speed
  
  sku {
    tier   = var.az_exproute_sku.tier
    family = var.az_exproute_sku.family
  }
  
  tags = var.az_tags
}

resource "azurerm_express_route_circuit_peering" "this" {
  count = anytrue([var.az_exproute_configure_peering, var.network_edge_configure_bgp]) ? 1 : 0

  express_route_circuit_name = azurerm_express_route_circuit.this.name
  resource_group_name        = local.az_resource_group_name

  peering_type                  = lookup(local.az_exproute_peering_types, var.az_exproute_peering_type, "AzurePrivatePeering")
  peer_asn                      = var.az_exproute_peering_customer_asn
  primary_peer_address_prefix   = var.az_exproute_peering_primary_address
  secondary_peer_address_prefix = var.az_exproute_peering_secondary_address
  vlan_id                       = var.az_exproute_peering_vlan_id
  shared_key                    = var.az_exproute_peering_shared_key

  dynamic "microsoft_peering_config" {
    for_each = var.az_exproute_peering_type == "MICROSOFT" ? [1] : []
    content {
      advertised_public_prefixes = var.az_exproute_peering_msft_advertised_public_prefixes
      customer_asn               = var.az_exproute_peering_msft_customer_asn
      routing_registry_name      = var.az_exproute_peering_msft_routing_registry_name
    }
  }
}

module "equinix-fabric-connection" {
  source = "equinix-labs/fabric-connection/equinix"
  version = "0.3.1"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name                      = var.fabric_connection_name
  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  speed_unit                = "MB"
  purchase_order_number     = var.fabric_purchase_order_number

  seller_profile_name      = "Azure ExpressRoute"
  seller_metro_code        = local.fabric_seller_metro_code
  seller_authorization_key = azurerm_express_route_circuit.this.service_key
  named_tag                = var.az_exproute_peering_type
  zside_vlan_ctag          = var.az_exproute_peering_vlan_id

  redundancy_type                     = var.redundancy_type
  secondary_name                      = var.fabric_secondary_connection_name
  secondary_port_name                 = var.fabric_secondary_port_name
  secondary_vlan_stag                 = var.fabric_secondary_vlan_stag
  secondary_service_token_id          = var.fabric_secondary_service_token_id
  network_edge_secondary_id           = var.network_edge_secondary_device_id
  network_edge_secondary_interface_id = var.network_edge_secondary_device_interface_id

  depends_on = [
    azurerm_express_route_circuit_peering.this[0]
  ]
}

resource "equinix_network_bgp" "primary" {
  count = alltrue([var.network_edge_configure_bgp, var.network_edge_device_id != ""]) ? 1 : 0

  connection_id      = module.equinix-fabric-connection.primary_connection.uuid
  local_ip_address   = "${cidrhost(azurerm_express_route_circuit_peering.this[0].primary_peer_address_prefix, 1)}/30"
  local_asn          = azurerm_express_route_circuit_peering.this[0].peer_asn
  remote_ip_address  = cidrhost(azurerm_express_route_circuit_peering.this[0].primary_peer_address_prefix, 2)
  remote_asn         = azurerm_express_route_circuit_peering.this[0].azure_asn
  authentication_key = var.az_exproute_peering_shared_key != "" ? var.az_exproute_peering_shared_key : null

  depends_on = [
    module.equinix-fabric-connection
  ]
}

resource "equinix_network_bgp" "secondary" {
  count = alltrue([var.network_edge_configure_bgp, var.network_edge_device_id != "", var.redundancy_type == "REDUNDANT" ]) ? 1 : 0

  connection_id      = module.equinix-fabric-connection.secondary_connection.uuid
  local_ip_address   = "${cidrhost(azurerm_express_route_circuit_peering.this[0].secondary_peer_address_prefix, 1)}/30"
  local_asn          = azurerm_express_route_circuit_peering.this[0].peer_asn
  remote_ip_address  = cidrhost(azurerm_express_route_circuit_peering.this[0].secondary_peer_address_prefix, 2)
  remote_asn         = azurerm_express_route_circuit_peering.this[0].azure_asn
  authentication_key = var.az_exproute_peering_shared_key != "" ? var.az_exproute_peering_shared_key :   null

  depends_on = [
    module.equinix-fabric-connection
  ]
}

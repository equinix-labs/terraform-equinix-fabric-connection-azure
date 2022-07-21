# Configure the Equinix Provider
# Interacting with Equinix Metal requires an API auth token in addition to the Equinix API client credentials.
# Please refer to provider documentation for details on supported authentication methods and parameters.
# https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
  auth_token    = var.equinix_provider_auth_token
}

# Configure the Microsoft Azure Provider
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure
provider "azurerm" {
  features {}
}

## Retrieve an existing equinix metal project
## If you prefer you can use resource equinix_metal_project instead to create a fresh project
data "equinix_metal_project" "this" {
  project_id = var.metal_project_id
}

locals {
  connection_name = format("conn-metal-azure-%s", lower(var.fabric_destination_metro_code))
}

# Create a new VLAN in Frankfurt
resource "equinix_metal_vlan" "this" {
  description = format("VLAN in %s", var.fabric_destination_metro_code)
  metro       = var.fabric_destination_metro_code
  project_id  = data.equinix_metal_project.this.project_id
}

## Request a connection service token in Equinix Metal
resource "equinix_metal_connection" "this" {
    name               = local.connection_name
    project_id         = data.equinix_metal_project.this.project_id
    metro              = var.fabric_destination_metro_code
    redundancy         = var.redundancy_type == "SINGLE" ? "primary" : "redundant"
    type               = "shared"
    service_token_type = "a_side"
    description        = format("connection to Azure in %s", var.fabric_destination_metro_code)
    speed              = format("%dMbps", var.fabric_speed)
    vlans              = [equinix_metal_vlan.this.vxlan]
}

## Configure the Equinix Fabric connection from Equinix Metal to Azure using the metal connection service token
module "equinix-fabric-connection-azure" {
  source = "equinix-labs/fabric-connection-azure/equinix"
  
  fabric_notification_users         = var.fabric_notification_users
  fabric_connection_name            = local.connection_name
  fabric_destination_metro_code     = var.fabric_destination_metro_code
  fabric_speed                      = var.fabric_speed
  fabric_service_token_id           = equinix_metal_connection.this.service_tokens.0.id
  fabric_secondary_service_token_id = var.redundancy_type == "REDUNDANT" ? equinix_metal_connection.this.service_tokens.1.id : null
  
  redundancy_type = var.redundancy_type

  az_create_resource_group = true
  az_resource_group_name   = "conn-equinix-metal-resources"
  az_region                = "West US" // required if az_create_resource_group is true
  
  ## BGP config
  az_exproute_configure_peering         = true
  az_exproute_peering_shared_key        = random_password.this.result
  # az_exproute_peering_type              = // If unspecified, default value "PRIVATE" will be used
  # az_exproute_peering_primary_address   = // If unspecified, default value "169.254.0.0/30" will be used
  # az_exproute_peering_secondary_address = // If unspecified, default value "169.254.0.4/30" will be used
  # az_exproute_peering_customer_asn      = // If unspecified, default value "65000" will be used
  # az_exproute_peering_vlan_id           = // If unspecified, default value 500 will be used

  ## MICROSOFT peering config - Applicable when az_exproute_peering_type is set to "MICROSOFT"
  # az_exproute_peering_msft_advertised_public_prefixes = // (required) A list of Advertised Public Prefixes
  # az_exproute_peering_msft_customer_asn               = "" // CustomerASN of the peering
  # az_exproute_peering_msft_routing_registry_name      = "" // Routing Registry i.e. 'ARIN', 'RIPE', 'AFRINIC'

  ## SKU for the ExpressRoute circuit - 
  ## If unspecified, default values "Standard" and "MeteredData" will be used
  # az_exproute_sku = {
  #   tier   = "Standard" // One of "Basic", "Local", "Standard", "Premium"
  #   family = "MeteredData" // One of "MeteredData", "UnlimitedData"
  # }
}

## Optionally we use an auto-generated password to enable authentication (shared key) between the two BGP peers
resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "$%&*()-_=+[]{}<>:?"
}

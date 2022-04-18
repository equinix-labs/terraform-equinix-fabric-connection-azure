variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."

  validation {
    condition     = length(var.fabric_notification_users) > 0
    error_message = "Notification list cannot be empty."
  }
}

variable "fabric_connection_name" {
  type        = string
  description = "Name of the connection resource that will be created. It will be auto-generated if not specified."
  default     = ""
}

variable "fabric_destination_metro_code" {
  type        = string
  description = <<EOF
  Destination Metro code where the connection will be created. If unspecified, it will be used the code that
  corresponds to the location of the Azure Resource Group.
  EOF
  default     = ""

  validation {
    condition = ( 
      var.fabric_destination_metro_code == "" ? true : can(regex("^[A-Z]{2}$", var.fabric_destination_metro_code))
    )
    error_message = "Valid metro code consits of two capital leters, i.e. 'FR', 'SV', 'DC'."
  }
}

variable "network_edge_device_id" {
  type        = string
  description = "Unique identifier of the Network Edge virtual device from which the connection would originate."
  default     = ""
}

variable "network_edge_device_interface_id" {
  type        = number
  description = <<EOF
  Applicable with 'network_edge_device_id', identifier of network interface on a given device, used for a connection.
  If unspecified, then first available interface will be selected.
  EOF
  default     = 0
}

variable "network_edge_configure_bgp" {
  type        = bool
  description = <<EOF
  Creation and management of Equinix Network Edge BGP peering configurations. Applicable with
  'network_edge_device_id'.
  EOF
  default = false
}

variable "fabric_port_name" {
  type        = string
  description = <<EOF
  Name of the buyer's port from which the connection would originate. One of 'fabric_port_name',
  'network_edge_device_id' or 'fabric_service_token_id' is required.
  EOF
  default     = ""
}

variable "fabric_vlan_stag" {
  type        = number
  description = <<EOF
  S-Tag/Outer-Tag of the primary connection - a numeric character ranging from 2 - 4094. Required if 'port_name' is
  specified.
  EOF
  default     = 0
}

variable "fabric_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the connection would originate.
  EOF
  default     = ""
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If unspecified, it will be used the minimum
  bandwidth available for the Azure ExpressRoute service profile.
  EOF
  default = 50
  validation {
    condition = contains([50, 100, 200, 500, 1000, 2000, 5000, 10000], var.fabric_speed)
    error_message = "Valid values are (50, 100, 200, 500, 1000, 2000, 5000, 10000)."
  } 
}

variable "fabric_purcharse_order_number" {
  type        = string
  description = "Connection's purchase order number to reflect on the invoice."
  default     = ""
}

variable "fabric_secondary_connection_name" {
  type        = string
  description = "Name of the secondary connection that will be created. It will be auto-generated if not specified."
  default     = ""
}

variable "fabric_secondary_port_name" {
  type        = string
  description = <<EOF
  Name of the buyer's port from which the secondary connection would originate. If unspecified, and
  'fabric_port_name', is specified, both primary and secondary connection will use 'fabric_port_name'.
  EOF
  default     = ""
}

variable "fabric_secondary_vlan_stag" {
  type        = number
  description = <<EOF
  S-Tag/Outer-Tag of the secondary connection. A numeric character ranging from 2 - 4094. Required if
  'fabric_secondary_port_name' is set. 
  EOF
  default     = 0
}


variable "fabric_secondary_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the secondary connection would originate.
  EOF
  default     = ""
}

variable "network_edge_secondary_device_id" {
  type        = string
  description = <<EOF
  Unique identifier of the secondary Network Edge virtual device from which the connection would originate. If not
  specified, and 'network_edge_device_id' is specified, and 'redundancy_type' is set to 'REDUNDANT' then primary edge
  device will be used.
  EOF
  default     = ""
}

variable "network_edge_secondary_device_interface_id" {
  type        = number
  description = <<EOF
  Applicable with 'network_edge_device_id' or 'network_edge_secondary_device_id', identifier of network interface on a
  given device, used for a connection. If unspecified, then first available interface will be selected.
  EOF
  default     = 0
}

variable az_region {
  type        = string
  description = <<EOF
  Specifies the Azure region where to create resources, i.e. 'West Europe', 'UK South'. Required if
  'az_create_resource_group' is set to 'true'. More details in
  [Azure geographies](https://azure.microsoft.com/en-us/global-infrastructure/geographies/#geographies)
  EOF
  default = ""
}

variable "az_create_resource_group" {
  type        = bool
  description = "Create an Azure Resource Group in which to create the resources."
  default     = true
}

variable "az_resource_group_name" {
  type        = string
  description = <<EOF
  The name of the resource group in which to create the ExpressRoute circuit. If unspecified, it will be
  auto-generated. Required if 'az_create_resource_group' is set to 'false'.
  EOF
  default     = ""
}

variable "az_exproute_circuit_name" {
  type        = string
  description = "The name of the ExpressRoute circuit. If unspecified, it will be auto-generated."
  default     = ""
}

variable az_exproute_location {
  type        = string
  description = <<EOF
  Specifies the supported Azure location where the ExpressRoute resource exists. If unspecified, it will be used the
  location of the Azure Resource Group.
  EOF
  default     = ""
}

variable az_exproute_equinix_peering_location {
  type        = string
  description = <<EOF
  The name of the Equinix peering location and not the 'az_exproute_location', i.e. 'Amsterdam', 'Bogota', 'Dallas'.
  If unspecified, it will be used one of the peering locations that correspond to the location of the Azure Resource
  Group. For more details please check 
  [expressroute locations - Equinix](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-locations#:~:text=Singapore%2C%20Singapore2-,Equinix,-Supported). 
  EOF
  default     = ""
}

variable "az_exproute_configure_peering" {
  type        = bool
  description = <<EOF
  Manages an ExpressRoute Circuit Peering. If 'network_edge_configure_bgp' is set to 'true', then peering will be
  configured as well in Azure even if 'az_exproute_configure_peering' is set to 'false'.
  EOF
  default     = false
}

variable "az_exproute_peering_type" {
  type        = string
  description = <<EOF
  The type of peering to set up in case when connecting to Azure Express Route. One of 'PRIVATE',
  'MICROSOFT'.
  EOF
  default     = "PRIVATE"

  validation {
    condition     = (contains(["PRIVATE", "MICROSOFT"], var.az_exproute_peering_type))
    error_message = "Valid values are (PRIVATE, MICROSOFT)."
  }
}

variable "az_exproute_peering_vlan_id" {
  type        = number
  description = "A valid VLAN ID to establish this peering on."
  default     = 500
}

variable "az_exproute_peering_customer_asn" {
  type        = number
  description = <<EOF
  The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration on customer side. The Either a
  16-bit or a 32-bit ASN. Can either be public or private.
  EOF
  default     = 65000
}

variable "az_exproute_peering_primary_address" {
  type        = string
  description = <<EOF
  A /30 subnet for the primary link. First usable IP address of the subnet should be assigned on the peered CE/PE-MSEE
  (Network Edge device or customer router). Microsoft will choose the second usable IP address of the subnet for the
  MSEE interface (cloud router).
  EOF
  default     = "123.0.0.0/30"
}

variable "az_exproute_peering_secondary_address" {
  type        = string
  description = <<EOF
  A /30 subnet for the secondary link. First usable IP address of the subnet should be assigned on the peered
  CE/PE-MSEE (Network Edge device or customer router). Microsoft will choose the second usable IP address of the subnet
  for the MSEE interface (cloud router).
  EOF
  default     = "123.0.0.4/30"
}

variable "az_exproute_peering_shared_key" {
  type        = string
  description = "The authentication key for BGP configuration."
  default     = ""

  validation {
    condition     = length(var.az_exproute_peering_shared_key) <= 25
    error_message = "Shared key can be a maximum of 25 characters."
  }
}

variable "az_exproute_peering_msft_advertised_public_prefixes" {
  type        = string
  description = "A list of Advertised Public Prefixes. Required when `az_exproute_peering_type` is set to 'MICROSOFT'."
  default     = ""
}

variable "az_exproute_peering_msft_customer_asn" {
  type        = string
  description = "The CustomerASN of the peering. Applicable when `az_exproute_peering_type` is set to 'MICROSOFT'."
  default     = ""
}

variable "az_exproute_peering_msft_routing_registry_name" {
  type        = string
  description = <<EOF
  The Routing Registry against which the AS number and prefixes are registered, i.e. 'ARIN', 'RIPE', 'AFRINIC'. Applicable
  when 'az_exproute_peering_type' is set to 'MICROSOFT'.
  EOF
  default     = ""
}

variable az_exproute_sku {
  type        = map(string)
  description = "A sku block for the ExpressRoute circuit."

  default = {
    tier   = "Standard"
    family = "MeteredData"
  }

  validation {
    condition = (
      alltrue([
          contains(["Basic", "Local", "Standard", "Premium"], var.az_exproute_sku.tier),
          contains(["MeteredData", "UnlimitedData"], var.az_exproute_sku.family)
      ])
    )
    error_message = "Unexpected value in sku settings."
  }
}

variable "az_tags" {
  type        = map(string)
  description = "Tags for Azure resources."

  default = {
    Terraform = "true"
  }
}

variable "redundancy_type" {
  type        = string
  description = <<EOF
  Whether to create a 'SINGLE' connection or 'REDUNDANT'. Azure recommends creating redundant Connections for
  ExpressRoute. Despite this recommendation, we are retaining the option for users to create a single Connection. If
  you choose to create a single Connection to ExpressRoute, there will be no Service Level Agreement (SLA).
  EOF
  default     = "REDUNDANT"

  validation {
    condition     = contains(["SINGLE", "REDUNDANT"], var.redundancy_type)
    error_message = "Valid values for 'redundancy_type' are (SINGLE, REDUNDANT)."
  } 
}

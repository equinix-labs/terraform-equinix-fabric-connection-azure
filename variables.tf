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
  Destination Metro code where the connection will be created. If you do not know the code,
  'fabric_destination_metro_name' can be use instead.
  EOF
  default     = ""

  validation {
    condition = ( 
      var.fabric_destination_metro_code == "" ? true : can(regex("^[A-Z]{2}$", var.fabric_destination_metro_code))
    )
    error_message = "Valid metro code consits of two capital leters, i.e. 'FR', 'SV', 'DC'."
  }
}

variable "fabric_destination_metro_name" {
  type        = string
  description = <<EOF
  Only required in the absence of 'fabric_destination_metro_code'. Metro name where the connection will be created,
  i.e. 'Frankfurt', 'Silicon Valley', 'Ashburn'. One of 'metro_code', 'metro_name' must be
  provided.
  EOF
  default     = ""
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
  If not specified then first available interface will be selected.
  EOF
  default     = 0
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
  S-Tag/Outer-Tag of the primary connection - a numeric character ranging from 2 - 4094. Required if
  'port_name' is specified.
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
  Speed/Bandwidth in Mbps to be allocated to the connection. If not specified, it will be used the minimum
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
  Name of the buyer's port from which the secondary connection would originate. If not specified, and
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
  "Unique identifier of the secondary Network Edge virtual device from which the connection would
  originate."
  EOF
  default     = ""
}

variable "network_edge_secondary_device_interface_id" {
  type        = number
  description = <<EOF
  Applicable with 'network_edge_device_id' or 'network_edge_secondary_device_id', identifier of network interface on a
  given device, used for a connection. If not specified then first available interface will be selected.
  EOF
  default     = 0
}

variable az_region {
  type        = string
  description = <<EOF
  Specifies the Azure region where to create resources, i.e. 'West Europe', 'UK South'. More details in
  [Azure geographies](https://azure.microsoft.com/en-us/global-infrastructure/geographies/#geographies)
  EOF
}

variable "az_create_resource_group" {
  type        = bool
  description = "Create an Azure Resource Group in which to create the ExpressRoute circuit."
  default     = true
}

variable "az_resource_group_name" {
  type        = string
  description = <<EOF
  The name of the resource group in which to create the ExpressRoute circuit. If unspecified, it will be
  auto-generated. Required if 'az_create_resource_group' is false.
  EOF
  default     = ""
}

variable "az_express_route_circuit_name" {
  type        = string
  description = "The name of the ExpressRoute circuit. If unspecified, it will be auto-generated."
  default     = ""
}

variable az_expressroute_peering_location {
  type        = string
  description = <<EOF
  Specifies the supported Azure location where to create resources, i.e. 'Frankfurt2'. More details in
  [expressroute locations - Equinix](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-locations#:~:text=Singapore%2C%20Singapore2-,Equinix,-Supported).
  EOF
}

variable az_expressroute_sku {
  type        = map(string)
  description = "A sku block for the ExpressRoute circuit."
  default     = {
    tier   = "Standard"
    family = "MeteredData"
  }
  validation {
    condition = (
      alltrue([
          contains(["Basic", "Local", "Standard", "Premium"], var.az_expressroute_sku.tier),
          contains(["MeteredData", "UnlimitedData"], var.az_expressroute_sku.family)
      ])
    )
    error_message = "Unexpected value in sku settings."
  }
}

variable "az_tags" {
  type        = map(string)
  description = "Tags for Azure resources."
  default     = {
    Terraform = "true"
  }
}

variable "az_named_tag" {
  type        = string
  description = <<EOF
  The type of peering to set up in case when connecting to Azure Express Route. One of 'PRIVATE', 'MICROSOFT',
  'MANUAL'.
  EOF
  default     = "PRIVATE"
}

variable "fabric_zside_vlan_ctag" {
  type        = number
  description = <<EOF
  C-Tag/Inner-Tag of the connection on the Z side. This is only applicable for named_tag 'MANUAL'. A numeric character
  ranging from 2 - 4094.
  EOF
  default     = 0
}

variable "redundancy_type" {
  type        = string
  description = <<EOF
  Whether to create a SINGLE connection or REDUNDANT. Azure recommends creating redundant Connections for ExpressRoute.
  Despite this recommendation, we are retaining the option for users to create a single Connection. If you choose to
  create a single Connection to ExpressRoute, there will be no Service Level Agreement (SLA).
  EOF
  default     = "REDUNDANT"

  validation {
    condition = (contains(["SINGLE", "REDUNDANT"], var.redundancy_type))
    error_message = "Valid values for 'redundancy_type' are (SINGLE, REDUNDANT)."
  } 
}

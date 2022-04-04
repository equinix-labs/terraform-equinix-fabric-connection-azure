output "fabric_connection_primary_uuid" {
  description = "Unique identifier of the connection."
  value       = module.equinix-fabric-connection.primary_connection.uuid
}

output "fabric_connection_primary_name" {
  description = "Name of the connection."
  value       = module.equinix-fabric-connection.primary_connection.name
}

output "fabric_connection_primary_status" {
  description = "Connection provisioning status."
  value       = module.equinix-fabric-connection.primary_connection.status
}

output "fabric_connection_primary_provider_status" {
  description = "Connection provisioning provider status."
  value       = module.equinix-fabric-connection.primary_connection.provider_status
}

output "fabric_connection_primary_speed" {
  description = "Connection speed."
  value       = module.equinix-fabric-connection.primary_connection.speed
}

output "fabric_connection_primary_speed_unit" {
  description = "Connection speed unit."
  value       = module.equinix-fabric-connection.primary_connection.speed_unit
}

output "fabric_connection_primary_seller_metro" {
  description = "Connection seller metro code."
  value       = module.equinix-fabric-connection.primary_connection.seller_metro_code
}

output "fabric_connection_secondary_uuid" {
  description = "Unique identifier of the secondary connection."
  value       = module.equinix-fabric-connection.secondary_connection.uuid
}

output "fabric_connection_secondary_name" {
  description = "Name of the secondary connection."
  value       = module.equinix-fabric-connection.secondary_connection.name
}

output "fabric_connection_secondary_status" {
  description = "Secondary connection provisioning status."
  value       = module.equinix-fabric-connection.secondary_connection.status
}

output "fabric_connection_secondary_provider_status" {
  description = "Secondary connection provisioning provider status."
  value       = module.equinix-fabric-connection.secondary_connection.provider_status
}

output "azure_resource_group_name" {
  description = "Resource group name."
  value = local.az_resource_group_name
}

output "azure_resource_group_id" {
  description = "Resource group ID."
  value = var.az_create_resource_group ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.this[0].id
}

output "azure_expressroute_circuit_id" {
  description = "ExpressRoute circuit ID."
  value = azurerm_express_route_circuit.this.id
}

output "azure_expressroute_circuit_state" {
  description = <<EOF
  ExpressRoute circuit provisioning state from Equinix. Possible values are 'NotProvisioned',
  'Provisioning', 'Provisioned', and 'Deprovisioning'.
  EOF
  value = azurerm_express_route_circuit.this.service_provider_provisioning_state
}

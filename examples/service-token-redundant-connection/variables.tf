variable "fabric_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the connection would originate.
  EOF
}

variable "fabric_secondary_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the secondary connection would originate.
  EOF
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the ExpressRoute circuit."
}

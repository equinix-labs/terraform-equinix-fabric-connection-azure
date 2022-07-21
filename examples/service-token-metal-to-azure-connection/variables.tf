variable "equinix_provider_client_id" {
  type        = string
  description = "API Consumer Key available under 'My Apps' in developer portal. This argument can also be specified with the EQUINIX_API_CLIENTID shell environment variable."
  default     = null
}

variable "equinix_provider_client_secret" {
  type        = string
  description = "API Consumer secret available under 'My Apps' in developer portal. This argument can also be specified with the EQUINIX_API_CLIENTSECRET shell environment variable."
  default     = null
}

variable "equinix_provider_auth_token" {
  type        = string
  description = "This is your Equinix Metal API Auth token. This can also be specified with the METAL_AUTH_TOKEN environment variable."
  default     = null
}

variable "metal_project_id" {
  type        = string
  description = "ID of the project where the connection is scoped to, used to look up the project."
}

variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."
  default     = ["example@equinix.com"]
}

variable "fabric_destination_metro_code" {
  type        = string
  description = "Destination Metro code where the connection will be created."
  default     = "SV"
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If unspecified, it will be used the minimum
  bandwidth available for the `Equinix Metal` service profile. Valid values are (50, 100, 200, 500, 1000, 2000, 5000, 10000).
  EOF
  default     = 50
}

variable "redundancy_type" {
  type        = string
  description = <<EOF
  Whether to create a 'SINGLE' connection or 'REDUNDANT' in the Azure side. Azure recommends creating redundant Connections for
  ExpressRoute. Despite this recommendation, we are retaining the option for users to create a single Connection. If
  you choose to create a single Connection to ExpressRoute, there will be no Service Level Agreement (SLA).
  EOF
  default     = "REDUNDANT"
}

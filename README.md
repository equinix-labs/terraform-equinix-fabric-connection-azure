## Equinix Fabric L2 Connection To Microsoft Azure ExpressRoute Terraform module

[![Experimental](https://img.shields.io/badge/Stability-Experimental-red.svg)](https://github.com/equinix-labs/standards#about-uniform-standards)
[![terraform](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml)

`terraform-equinix-fabric-connection-azure` is a Terraform module that utilizes [Terraform provider for Equinix](https://registry.terraform.io/providers/equinix/equinix/latest) and [Terraform provider for Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) to set up an Equinix Fabric L2 connection to Microsoft Azure ExpressRoute.

As part of Platform Equinix, your infrastructure can connect with other parties, such as public cloud providers, network service providers, or your own colocation cages in Equinix by defining an [Equinix Fabric - software-defined interconnection](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/Fabric-landing-main.htm).

This module creates a resource group or uses an existing one, an ExpressRoute circuit in Azure, and the redundant (optionally non-redundant) l2 connection in Equinix Fabric using the ExpressRoute service key. ExpressRoute circuit peering (Private or Microsoft) and Network Edge BGP session can be optionally configured.

```html
     Origin                                              Destination
    (A-side)                                              (Z-side)              ┌────────────────────────┐
                                                                                │  (Microsoft Peering)   │
┌────────────────┐                                 ┌────────────────────┐       │  Office 365 / Dynamics │──┐
│ Equinix Fabric │         Equinix Fabric          │                    │──────►│  365 / Public services │  │
│ Port / Network ├─────   Single/Redundant   ─────►│        Azure       │       └────────────────────────┘  │
│ Edge Device /  │    l2 connection connection     │    ExpressRoute    │       ┌────────────────────────┐  │
│ Service Token  ├─────  (50 Mbps - 10 Gbps) ─────►│                    │──────►│   (Private Peering)    │  │
└────────────────┘                                 └────────────────────┘       │    Virtual Networks    │──│
        │                                                                       └────────────────────────┘  │
        └ - - - - - - - - - - Network Edge Device - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ┘
                                   BGP peering
```

### Usage

This project is experimental and supported by the user community. Equinix does not provide support for this project.

Install Terraform using the official guides at <https://learn.hashicorp.com/tutorials/terraform/install-cli>.

This project may be forked, cloned, or downloaded and modified as needed as the base in your integrations and deployments.

This project may also be used as a [Terraform module](https://learn.hashicorp.com/collections/terraform/modules).

To use this module in a new project, create a file such as:

```hcl
# main.tf
provider "equinix" {}

provider "azurerm" {
  features {}
}

variable "port_primary_name" {}
variable "port_secondary_name" {}

module "equinix-fabric-connection-azure" {
  source  = "equinix-labs/fabric-connection-azure/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_speed               = 400
  fabric_port_name           = var.port_primary_name
  fabric_vlan_stag           = 1010
  fabric_secondary_port_name = var.port_secondary_name
  fabric_secondary_vlan_stag = 1020

  az_region = "Japan East"
}
```

Run `terraform init -upgrade` and `terraform apply`.

#### Resources

| Name | Type |
| :-----: | :------: |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [equinix-fabric-connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection/equinix/latest?tab=inputs) | module |
| [azurerm_express_route_circuit.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_express_route_circuit_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [equinix_network_bgp.primary](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/equinix_network_bgp) | resource |
| [equinix_network_bgp.secondary](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/equinix_network_bgp) | resource |

#### Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest?tab=inputs> for a description of all variables.

#### Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest?tab=outputs> for a description of all outputs.

### Examples

- [examples/fabric-port-redundant-connection](examples/fabric-port-redundant-connection/)
- [examples/service-token-redundant-connection](examples/service-token-redundant-connection/)

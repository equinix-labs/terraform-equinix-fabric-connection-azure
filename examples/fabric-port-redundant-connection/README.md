# Fabric Port Redundant Connection Example

This example demonstrates usage of the Equinix Connection module to establish a redundant Equinix Fabric L2 Connection from a single Equinix Fabric port to Azure ExpressRoute. It will:

- Create resource group.
- Create ExpressRoute circuit.
- Create Equinix Fabric l2 connection for Microsoft Azure service profile with 100Mbps bandwidth and private peering.

## Usage

```bash
terraform init
terraform apply
```

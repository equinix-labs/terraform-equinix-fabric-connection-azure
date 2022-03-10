# Simple Example

This example demonstrates usage of the Equinix Connection module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Fabric port to Azure ExpressRoute. It will:

- Create resource groupo, if does not exist
- Create ExpressRoute circuit
- Create Equinix Fabric l2 connection for Microsoft Azure service profile with 100Mbps bandwidth and private peering.

## Usage

```bash
terraform init
terraform apply
```

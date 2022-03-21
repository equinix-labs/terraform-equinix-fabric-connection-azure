# Fabric Service Token Redundant Connection Example

This example demonstrates usage of the Equinix Connection module to establish a redundant Equinix Fabric L2 Connection from another customer Equinix Fabric ports pair using two [A-Side Token](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/service%20tokens/Fabric-Service-Tokens.htm) to Azure ExpressRoute. It will:

- Use an existing resource group.
- Create ExpressRoute circuit.
- Create Equinix Fabric l2 connection for Microsoft Azure service profile with 100Mbps bandwidth and private peering.

## Usage

```bash
terraform init
terraform apply
```

# Fabric Service Token Redundant Connection Example

This example demonstrates usage of the Equinix Connection module to establish a redundant Equinix Fabric L2 Connection from another customer Equinix Fabric ports pair using two [A-Side Token](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/service%20tokens/Fabric-Service-Tokens.htm) to Azure ExpressRoute. It will:

- Use an existing resource group.
- Create ExpressRoute circuit.
- Create Equinix Fabric l2 connection for Microsoft Azure service profile with 100Mbps bandwidth and private peering.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-azure.git
cd terraform-equinix-fabric-connection-azure/examples/service-token-redundant-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest/examples/service-token-redundant-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest/examples/service-token-redundant-connection?tab=outputs> for a description of all outputs.

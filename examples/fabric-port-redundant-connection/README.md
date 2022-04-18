# Fabric Port Redundant Connection Example

This example demonstrates a simple usage of the Equinix Connection Azure module to establish a redundant Equinix Fabric L2 Connection from two Equinix Fabric ports to Azure ExpressRoute. It will:

- Create resource group with auto-generated name and specified region.
- Create ExpressRoute circuit.
- Create Equinix Fabric l2 connection for 'Microsoft Azure' service profile with 50Mbps bandwidth (default if not specified) and private peering.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-azure.git
cd terraform-equinix-fabric-connection-azure/examples/fabric-port-redundant-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest/examples/fabric-port-redundant-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest/examples/fabric-port-redundant-connection?tab=outputs> for a description of all outputs.

# Complete Equinix Metal connection (a-side) to Azure

~> Equinix Metal connection with automated `a_side` service token is not generally available and may not be enabled yet for your organization.

This example demonstrates usage of the Equinix Connection Azure module to establish an Equinix Fabric L2 Connection from Equinix Metal (a-side) to Azure ExpressRoute using an [A-Side Token](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/service%20tokens/Fabric-Service-Tokens.htm).
It will:

- Use an existing Equinix Metal project.
- Create an Equinix Metal VLAN in selected metro Silicon Valley (SV).
- Request an Equinix Metal shared redundant connection in SV.
- Attach the Equinix Metal VLAN to the Virtual Circuit created for the Equinix Metal connection.
- Create an Azure resource group in West US.
- Create an ExpressRoute circuit.
- Provision an Equinix Fabric l2 connection for Microsoft Azure service profile with specified bandwidth and private peering.
- Configure an ExpressRoute Circuit Peering.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-azure.git
cd terraform-equinix-fabric-connection-azure/examples/service-token-metal-to-azure-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest/examples/service-token-metal-to-azure-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-azure/equinix/latest/examples/service-token-metal-to-azure-connection?tab=outputs> for a description of all outputs.

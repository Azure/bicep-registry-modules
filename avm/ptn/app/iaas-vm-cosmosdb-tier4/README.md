# IaaS VM with CosmosDB MongoDB vCore Tier 4

This Bicep module deploys a tier 4 infrastructure as code solution with a Linux virtual machine and CosmosDB MongoDB vCore database using Azure Verified Modules (AVM).

## Resources Deployed

- Virtual Network with multiple subnets
- Network Security Groups
- Private DNS Zones
- Virtual Machine (Linux)
- SSH Public Key
- Storage Account (for boot diagnostics)
- Load Balancer
- CosmosDB MongoDB vCore Cluster
- Private Endpoints for secure connectivity
- Recovery Services Vault

## Prerequisites

- Azure CLI installed
- Bicep CLI installed
- Sufficient permissions to deploy resources in your Azure subscription

## Deployment Instructions

1. Login to Azure:

```bash
az login
az account set --subscription <subscription-id>
```

2. Create a resource group (if not already existing):

```bash
az group create --name <resource-group-name> --location <location>
```

3. Deploy the Bicep template:

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters name=<solution-name> \
              cosmosAdminUsername=<admin-username> \
              cosmosAdminPassword=<admin-password>
```

You can also create a parameters file (see the provided parameters.json file in the repository) and reference it:

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters @parameters.json
```

## Sample Parameters File

A sample parameters.json file is included in the repository. You can modify it according to your needs:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "iaasvm001"
    },
    "location": {
      "value": "eastus"
    },
    "cosmosAdminUsername": {
      "value": "cosmosadmin"
    },
    "cosmosAdminPassword": {
      "value": "YourStrongPasswordHere!"
    }
    // Add other parameters as needed
  }
}
```

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| name | string | | Name of the solution which is used to generate unique resource names |
| location | string | resourceGroup().location | Location for all resources |
| tags | object | {} | Tags for all resources |
| enableDefaultTelemetry | bool | true | Enable telemetry via the Customer Usage Attribution ID (GUID) |
| applicationNsgRules | array | [] | Network security group rules for the ApplicationSubnet |
| vmNsgRules | array | [HTTP rules] | Network security group rules for the VM |
| vnetAddressPrefix | string | '10.0.0.0/16' | Address prefix for the virtual network |
| subnets | array | [multiple subnets] | Subnet configuration for the virtual network |
| vmSize | string | 'Standard_D2s_v3' | Size of the virtual machine |
| adminUsername | string | 'azureuser' | Admin username for the virtual machine |
| storageAccountSku | object | Standard_LRS | Storage account SKU |
| lbFrontendPort | int | 80 | Load balancer frontend port |
| lbBackendPort | int | 80 | Load balancer backend port |
| cosmosAdminUsername | securestring | | CosmosDB MongoDB vCore username |
| cosmosAdminPassword | securestring | | CosmosDB MongoDB vCore password |
| cosmosTier | string | 'M30' | CosmosDB MongoDB vCore tier |
| cosmosStorageSizeGB | int | 128 | CosmosDB MongoDB vCore storage size in GB |
| cosmosShardCount | int | 1 | CosmosDB MongoDB vCore shard count |

## Outputs

| Output Name | Description |
|-------------|-------------|
| virtualMachineResourceId | The resource ID of the virtual machine |
| cosmosDbResourceId | The resource ID of the CosmosDB MongoDB vCore cluster |
| virtualNetworkResourceId | The resource ID of the virtual network |
| loadBalancerResourceId | The resource ID of the load balancer |

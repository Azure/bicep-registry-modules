# PaaS ASE CosmosDB Tier 4

This Bicep module deploys a tier 4 PaaS architecture with App Service Environment (ASE) and Azure Cosmos DB using Azure Verified Modules (AVM).

## Resources Deployed

- Virtual Network with subnets
- Network Security Groups
- Private DNS Zones
- App Service Environment (ASE v3)
- App Service Plan
- CosmosDB Account (SQL API)
- Redis Cache
- Private Endpoints for secure connectivity

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
  --parameters name=p001
```

You can also create a parameters file (see the provided parameters.json file in the repository) and reference it:

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters @parameters.json
```

## Parameters

| Parameter Name | Type | Default Value | Description |
|----------------|------|---------------|-------------|
| enableDefaultTelemetry | bool | true | Enable telemetry via a Globally Unique Identifier (GUID) |
| location | string | resourceGroup().location | Location for all resources |
| name | string | 'p001' | The name of the deployment |
| suffix | string | '' | Suffix for all resources |
| tags | object | {} | Tags of the resource |
| vNetAddressPrefix | string | '192.168.250.0/23' | Virtual Network address space |
| defaultSubnetAddressPrefix | string | '192.168.250.0/24' | Default subnet address prefix |
| privateEndpointSubnetAddressPrefix | string | '192.168.251.0/24' | PrivateEndpoint subnet address prefix |

## Outputs

| Output Name | Description |
|-------------|-------------|
| vnetResourceId | The resource ID of the virtual network |
| cosmosDbResourceId | The resource ID of the CosmosDB account |
| redisCacheResourceId | The resource ID of the Redis cache |
| appServiceEnvironmentResourceId | The resource ID of the App Service Environment |
| appServicePlanResourceId | The resource ID of the App Service Plan |

## Sample Parameters File

A sample parameters.json file is included in the repository. You can modify it according to your needs:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "paasase001"
    },
    "location": {
      "value": "eastus"
    },
    "suffix": {
      "value": "prod"
    }
    // Add other parameters as needed
  }
}
```
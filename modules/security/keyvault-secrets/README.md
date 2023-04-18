# Azure Key Vault Secret

Bicep module for simplified creation of an Azure Key Vault Secret for an Azure Resource.

## Description

This template creates creates a Azure Key Vault Secert in an existing Azure Key Vault with a secrets from a different Azure service.
It has parameters for setting the Key Vault name, prefix, and secret names and values.
It enables adding a secret from Storage Accounts, Cosmos DB, Cosmos DB's Cassandra DB API, Event Hubs, Redis Cache, Azure PSQL, Azure MySQL, Azure SQL, Azure Maps, Operational Insights Workspace, Batch Accounts, or Container Registry Accounts.
The template uses the 'secrets.bicep' module to manage secrets and returns output values for Key Vault ID, name, secret ID, secret name, secret URI, and secret URI with version.

## Parameters

| Name                                    | Type           | Required | Description                                                                                               |
| :-------------------------------------- | :------------: | :------: | :-------------------------------------------------------------------------------------------------------- |
| `prefix`                                | `string`       | No       | Prefix of Azure Key Vault Resource Name                                                                   |
| `name`                                  | `string`       | No       | Name of the Key Vault                                                                                     |
| `secretName`                            | `string`       | Yes      | Name of Secret to add to Key Vault. Required when provided a secretValue.                                 |
| `secretValue`                           | `securestring` | No       | Value of Secret to add to Key Vault. The secretName parameter must also be provided when adding a secret. |
| `storageAccountName`                    | `string`       | No       | The name of the storage account to add secrets from.                                                      |
| `cosmosDBName`                          | `string`       | No       | The name of the Cosmos DB to add secrets from.                                                            |
| `locationString`                        | `string`       | No       | Custom Location String for Cassandra DB                                                                   |
| `cassandraDBName`                       | `string`       | No       | The name of the Cassandra Keyspace to add secrets from.                                                   |
| `eventHubNamespaceName`                 | `string`       | No       | Name of the Event Hub Namespace                                                                           |
| `eventHubName`                          | `string`       | No       | Name of the Event Hub                                                                                     |
| `eventHubAuthorizationRulesName`        | `string`       | No       | Name of the secret for the Event Hub                                                                      |
| `redisCacheName`                        | `string`       | No       | Name of the Redis Cache                                                                                   |
| `azurePsqlServerName`                   | `string`       | No       | Name of the Azure PSQL Server                                                                             |
| `azureMySQLServerName`                  | `string`       | No       | Name of the Azure MySQL Server                                                                            |
| `azureSqlServerName`                    | `string`       | No       | Name of the Azure SQL Server                                                                              |
| `azureMapsAccountName`                  | `string`       | No       | Name of the Azure Maps Account                                                                            |
| `azureOperationalInsightsWorkspaceName` | `string`       | No       | Name of the Azure OperationalInsights Workspace                                                           |
| `azureBatchAccountName`                 | `string`       | No       | Name of the Azure Batch Account                                                                           |
| `azureContainerRegistryAccountName`     | `string`       | No       | Name of the Azure ContainerRegistry Account                                                               |

## Outputs

| Name                 | Type   | Description             |
| :------------------- | :----: | :---------------------- |
| name                 | string | Key Vault Name          |
| id                   | string | Key Vault Id            |
| secretId             | string | Key Vault Seceret Id    |
| secretName           | string | Key Vault Secert Name   |
| secretUri            | string | Secret URI              |
| secretUriWithVersion | string | Secret URI with version |

## Examples

### Example 1

```bicep
param location string = 'eastus'
param name string = 'mykeyvault'

module keyVault 'br/public:security/keyvault:1.0.1' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: name
  }
}
```

### Example 2

```bicep
param roleAssignments array = [
  '4633458b-17de-408a-b874-0445c86b69e6' // rbacSecretsReaderRole
]

module keyVault 'br/public:security/keyvault:1.0.1' = {
  name: 'myKeyVault'
  params: {
    location: location
    name: name
  }
}
```

### Example 3

This example deploys a Virtual Network with the specified parameters and a subnet with the desired address space.

```bicep
param location string

module vnet 'br/public:network/virtual-network:1.0.1' = {
  name: 'vnet'
  params: {
    location: location
    name: 'az-vnet-kv-01'
    addressPrefixes: [ '10.0.0.0/16' ]
    subnets: [
      {
        name: 'az-subnet-kv-01'
        addressPrefix: '10.0.0.0/24'
        serviceEndpoints: [{ service: 'Microsoft.KeyVault' }]
      }
    ]
  }
}

module keyVaultModule 'br/public:security/keyvault:1.0.1' = {
  name: 'keyVault-in-vnet'
  params: {
    location: location
    subnetID: vnet.outputs.subnetResourceIds[0]
  }
}
```

### Example 4

This example is a module deployment that adds a secret to an existing Key Vault.

```bicep
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name
param keyVaultName string
param storageSecretName string

@secure()
param storageAccountSecret string

module secretsBatch 'br/public:security/keyvault:1.0.1' = {
  name: 'secrets-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    keyVaultName: keyVaultName
    newOrExisting: 'existing'
    secretName: storageSecretName
    secretValue: storageAccountSecret
  }
}
```
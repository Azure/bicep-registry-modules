# Azure Gaming: Connected Resources

This module is used by other Azure Gaming modules and applications to create core Azure services

## Description

This module is used to deploy core Azure services in Azure Gaming deployments.
These resources can be configured to use availability zones in available regions.

## Parameters

| Name                          | Type     | Required | Description                                                                                                                                                    |
| :---------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                    | `string` | No       | Deployment Location                                                                                                                                            |
| `secondaryLocations`          | `array`  | No       | Secondary Deployment Locations                                                                                                                                 |
| `newOrExistingKubernetes`     | `string` | No       | Set to create a new or use an existing AKS                                                                                                                     |
| `aksName`                     | `string` | No       | AKS Resource Name                                                                                                                                              |
| `agentPoolCount`              | `int`    | No       |                                                                                                                                                                |
| `agentPoolName`               | `string` | No       |                                                                                                                                                                |
| `vmSize`                      | `string` | No       |                                                                                                                                                                |
| `newOrExistingStorageAccount` | `string` | No       | Set to create a new or use an existing Storage Account                                                                                                         |
| `storageAccountName`          | `string` | No       | Storage Account Resource Name                                                                                                                                  |
| `newOrExistingKeyVault`       | `string` | No       | Set to create a new or use an existing Key Vault                                                                                                               |
| `keyVaultName`                | `string` | No       | Key Vault Resource Name                                                                                                                                        |
| `newOrExistingPublicIp`       | `string` | No       | Set to create a new or use an existing Public IP                                                                                                               |
| `publicIpName`                | `string` | No       | Public IP Resource Name                                                                                                                                        |
| `newOrExistingTrafficManager` | `string` | No       | Set to create a new or use an existing Traffic Manager Profile                                                                                                 |
| `trafficManagerName`          | `string` | No       | Traffic Manager Resource Name                                                                                                                                  |
| `trafficManagerDnsName`       | `string` | No       | Relative DNS name for the traffic manager profile, must be globally unique.                                                                                    |
| `newOrExistingCosmosDB`       | `string` | No       | Set to create a new or use an existing Cosmos DB                                                                                                               |
| `cosmosDBName`                | `string` | No       | Cosmos DB Resource Name                                                                                                                                        |
| `assignRole`                  | `bool`   | No       | Running this template requires roleAssignment permission on the Resource Group, which require an Owner role. Set this to false to deploy some of the resources |
| `isZoneRedundant`             | `bool`   | No       | Enable Zonal Redunancy for supported regions                                                                                                                   |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```
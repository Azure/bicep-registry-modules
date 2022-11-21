# 

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                          | Type     | Required | Description                                                                                                                                                    |
| :---------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                    | `string` | No       | Deployment Location                                                                                                                                            |
| `resourceGroupName`           | `string` | No       | Resource Group Name                                                                                                                                            |
| `secondaryLocations`          | `array`  | No       | Secondary Deployment Locations                                                                                                                                 |
| `newOrExistingKubernetes`     | `string` | No       |                                                                                                                                                                |
| `aksName`                     | `string` | No       |                                                                                                                                                                |
| `agentPoolCount`              | `int`    | No       |                                                                                                                                                                |
| `agentPoolName`               | `string` | No       |                                                                                                                                                                |
| `vmSize`                      | `string` | No       |                                                                                                                                                                |
| `newOrExistingStorageAccount` | `string` | No       |                                                                                                                                                                |
| `storageAccountName`          | `string` | No       |                                                                                                                                                                |
| `storageResourceGroupName`    | `string` | No       |                                                                                                                                                                |
| `newOrExistingKeyVault`       | `string` | No       |                                                                                                                                                                |
| `keyVaultName`                | `string` | No       |                                                                                                                                                                |
| `newOrExistingPublicIp`       | `string` | No       |                                                                                                                                                                |
| `publicIpName`                | `string` | No       |                                                                                                                                                                |
| `newOrExistingTrafficManager` | `string` | No       |                                                                                                                                                                |
| `trafficManagerName`          | `string` | No       |                                                                                                                                                                |
| `trafficManagerDnsName`       | `string` | No       | Relative DNS name for the traffic manager profile, must be globally unique.                                                                                    |
| `newOrExistingCosmosDB`       | `string` | No       |                                                                                                                                                                |
| `cosmosDBName`                | `string` | No       |                                                                                                                                                                |
| `cosmosDBRG`                  | `string` | No       |                                                                                                                                                                |
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
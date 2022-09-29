# Unreal Cloud DDC

Cloud cache for Unreal Engine 5 DDC files

## Description

Unreal Cloud DDC is a centralized cloud-based cache designed to be used in conjunction with Epic Game's Unreal Cloud DDC to reduce build times and improve overall build performance. Unreal Cloud DDC enables you and your entire development team to connect and use Epic Game's Unreal Cloud DDC service.

This Bicep module can be used to deploy resources shared between multipule deployments, or to update to the lastest version of the Marketplace application.

## Parameters

| Name                          | Type     | Required | Description                                                                                                                |
| :---------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------- |
| `location`                    | `string` | No       | Deployment Location                                                                                                        |
| `secondaryLocations`          | `array`  | No       | Secondary Deployment Locations                                                                                             |
| `newOrExistingKubernetes`     | `string` | No       | Create new or use existing Kubernetes resource                                                                             |
| `name`                        | `string` | No       | Kubernetes cluster name                                                                                                    |
| `agentPoolCount`              | `int`    | No       | Agent Pool Count                                                                                                           |
| `agentPoolName`               | `string` | No       | Agent Pool Name                                                                                                            |
| `vmSize`                      | `string` | No       | Agent Pool VM Size                                                                                                         |
| `hostname`                    | `string` | No       | Horde Storage Endpoint                                                                                                     |
| `isZoneRedundant`             | `bool`   | No       | Enable Zone Redundancy in available regions (when true, unsupported regions are automatically set to false)                |
| `newOrExistingStorageAccount` | `string` | No       | Create new or use existing Storage Account                                                                                 |
| `storageAccountName`          | `string` | No       | Storage Account name                                                                                                       |
| `newOrExistingKeyVault`       | `string` | No       | Create new or use existing Key Vault                                                                                       |
| `keyVaultName`                | `string` | No       | Key Vault name                                                                                                             |
| `newOrExistingPublicIp`       | `string` | No       | Create new or use existing Public IP Address                                                                               |
| `publicIpName`                | `string` | No       | Public IP Address name                                                                                                     |
| `newOrExistingTrafficManager` | `string` | No       | Create new or use existing Traffic Manager Profile                                                                         |
| `trafficManagerName`          | `string` | No       | Traffic Manager Profile name                                                                                               |
| `trafficManagerDnsName`       | `string` | No       | Relative DNS name for the traffic manager profile, must be globally unique.                                                |
| `newOrExistingCosmosDB`       | `string` | No       | Create new or use existing Cosmos DB Resource                                                                              |
| `cosmosDBName`                | `string` | No       | Cosmos DB Resource name                                                                                                    |
| `servicePrincipalObjectID`    | `string` | No       | Service Principal Object ID                                                                                                |
| `servicePrincipalClientID`    | `string` | No       | Service Principal Client ID                                                                                                |
| `certificateName`             | `string` | No       | Name of Certificate (Default certificate is self-signed)                                                                   |
| `unityEULA`                   | `bool`   | No       | Set to true to agree to the terms and conditions of the Epic Games EULA found here: https://store.epicgames.com/en-US/eula |
| `managedResourceGroupSuffix`  | `string` | No       | Managed Resource Group Name                                                                                                |
| `publisher`                   | `string` | No       | Publisher Environment                                                                                                      |
| `publishers`                  | `object` | No       | Publisher Listings                                                                                                         |
| `certificateIssuer`           | `string` | No       | Certificate Issuer (Default certificate is self-signed, and value is Self)                                                 |
| `issuerProvider`              | `string` | No       | Issuer Provider (Required when creating a new signed certificate)                                                          |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
module deployUnrealCloud '../main.bicep' = {
  name: 'Unreal-Cloud-DDC'
  params: {
    location: location
  }
}

```

### Example 2

```bicep
```
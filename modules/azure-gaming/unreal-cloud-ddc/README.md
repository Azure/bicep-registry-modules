# Unreal Cloud DDC

Unreal Cloud DDC for Unreal Engine game development.

## Description

Unreal Cloud DDC is a centralized cloud-based cache designed to be used in conjunction with Epic Game's Unreal Cloud DDC to reduce build times and improve overall build performance. Unreal Cloud DDC enables you and your entire development team to connect and use Epic Game's Unreal Cloud DDC service.

This technology implements horizontally scalable, cloud-ready services to provide distributed compute and storage functionality for medium size and larger teams (>10 devs). The compute service manages agents and schedules work to execute on them. The storage service provides content-addressable storage backed by cloud object stores. Integrating storage and compute services allows caching, de-duplication, and locating data close to agents.

In Unreal Engine 5 (UE5), ‘Unreal Cloud DDC’ is an optional service which users can enable and connect to cloud storage. Simplify provide the Unreal Cloud DDC URL and complete the authentication prompts to connect to your Unreal Cloud DDC deployment. By leveraging the ability to store smaller pre-computed elements, Unreal Cloud DDC makes it more efficient for sharing assets between developers.

[Learn more about Unreal Cloud DDC on Azure.](https://learn.microsoft.com/en-us/gaming/azure/unreal-cloud-ddc/overview)

## Parameters

| Name                                             | Type           | Required | Description                                                                                                                                                    |
| :----------------------------------------------- | :------------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                                       | `string`       | Yes      | Deployment Location                                                                                                                                            |
| `secondaryLocations`                             | `array`        | No       | Secondary Deployment Locations                                                                                                                                 |
| `newOrExistingKubernetes`                        | `string`       | No       | New or Existing Kubernentes Resources                                                                                                                          |
| `aksName`                                        | `string`       | No       | Name of Kubernetes Resource                                                                                                                                    |
| `agentPoolCount`                                 | `int`          | No       | Number of Kubernetes Nodes                                                                                                                                     |
| `agentPoolName`                                  | `string`       | No       | Name of Kubernetes Agent Pool                                                                                                                                  |
| `vmSize`                                         | `string`       | No       | Virtual Machine Skew for Kubernetes                                                                                                                            |
| `hostname`                                       | `string`       | No       | Hostname of Deployment                                                                                                                                         |
| `dnsZoneName`                                    | `string`       | No       | If not empty, use the given existing DNS Zone for DNS entries and use shortHostname instead of hostname.                                                       |
| `dnsZoneResourceGroupName`                       | `string`       | No       | If dnsZoneName is specified, its resource group must specified as well, since it is not expected to be part of the deployment resource group.                  |
| `shortHostname`                                  | `string`       | No       | Short hostname of deployment if dnsZoneName is specified                                                                                                       |
| `enableCert`                                     | `bool`         | No       | Enable to configure certificate. Default: true                                                                                                                 |
| `certificateIssuer`                              | `string`       | No       | Unknown, Self, or {IssuerName} for certificate signing                                                                                                         |
| `issuerProvider`                                 | `string`       | No       | Certificate Issuer Provider                                                                                                                                    |
| `assignRole`                                     | `bool`         | No       | Running this template requires roleAssignment permission on the Resource Group, which require an Owner role. Set this to false to deploy some of the resources |
| `isZoneRedundant`                                | `bool`         | No       | Enable Zonal Redunancy for supported regions                                                                                                                   |
| `newOrExistingStorageAccount`                    | `string`       | No       | Create new or use existing Storage Account.                                                                                                                    |
| `storageAccountName`                             | `string`       | No       | Name of Storage Account resource                                                                                                                               |
| `storageResourceGroupName`                       | `string`       | No       | Name of Storage Account Resource Group                                                                                                                         |
| `newOrExistingKeyVault`                          | `string`       | No       | Create new or use existing Key Vault                                                                                                                           |
| `keyVaultName`                                   | `string`       | No       | Name of Key Vault resource                                                                                                                                     |
| `newOrExistingPublicIp`                          | `string`       | No       | Create new or use existing Public IP resource                                                                                                                  |
| `publicIpName`                                   | `string`       | No       | Name of Public IP Resource                                                                                                                                     |
| `newOrExistingTrafficManager`                    | `string`       | No       | Create new or use existing Traffic Manager Profile.                                                                                                            |
| `trafficManagerName`                             | `string`       | No       | New or existing Traffic Manager Profile.                                                                                                                       |
| `trafficManagerDnsName`                          | `string`       | No       | Relative DNS name for the traffic manager profile, must be globally unique.                                                                                    |
| `newOrExistingCosmosDB`                          | `string`       | No       | Create new or use existing CosmosDB for Cassandra.                                                                                                             |
| `cosmosDBName`                                   | `string`       | No       | Name of Cosmos DB resource.                                                                                                                                    |
| `cosmosDBRG`                                     | `string`       | No       | Name of Cosmos DB Resource Group.                                                                                                                              |
| `servicePrincipalClientID`                       | `string`       | No       | Application Managed Identity ID                                                                                                                                |
| `workerServicePrincipalClientID`                 | `string`       | No       | Worker Managed Identity ID, required for geo-replication.                                                                                                      |
| `workerServicePrincipalSecret`                   | `securestring` | No       | Worker Managed Identity Secret, which will be stored in Key Vault, and is required for geo-replication.                                                        |
| `certificateName`                                | `string`       | No       | Name of Certificate (Default certificate is self-signed)                                                                                                       |
| `epicEULA`                                       | `bool`         | No       | Set to true to agree to the terms and conditions of the Epic Games EULA found here: https://store.epicgames.com/en-US/eula                                     |
| `azureTenantID`                                  | `string`       | No       | Active Directory Tennat ID                                                                                                                                     |
| `keyVaultTenantID`                               | `string`       | No       | Tenant ID for Key Vault                                                                                                                                        |
| `loginTenantID`                                  | `string`       | No       | Tenant ID for Authentication                                                                                                                                   |
| `CleanOldRefRecords`                             | `bool`         | No       | Delete old ref records no longer in use across the entire system                                                                                               |
| `CleanOldBlobs`                                  | `bool`         | No       | Delete old blobs that are no longer referenced by any ref - this runs in each region to cleanup that regions blob stores                                       |
| `cassandraConnectionString`                      | `securestring` | No       | Connection String of User Provided Cassandra Database                                                                                                          |
| `storageConnectionStrings`                       | `array`        | No       | Connection Strings of User Provided Storage Accounts                                                                                                           |
| `imageVersion`                                   | `string`       | No       | Version of the image to deploy                                                                                                                                 |
| `helmChart`                                      | `string`       | Yes      | Name of the Helm chart to deploy                                                                                                                               |
| `helmVersion`                                    | `string`       | No       | Helm Chart Version                                                                                                                                             |
| `helmName`                                       | `string`       | No       | Name of the Helm release                                                                                                                                       |
| `helmNamespace`                                  | `string`       | No       | Namespace of the Helm release                                                                                                                                  |
| `siteName`                                       | `string`       | No       | Name of the site                                                                                                                                               |
| `managedIdentityPrefix`                          | `string`       | No       | Prefix of Managed Identity used during deployment                                                                                                              |
| `useExistingManagedIdentity`                     | `bool`         | No       | Does the Managed Identity already exists, or should be created                                                                                                 |
| `existingManagedIdentitySubId`                   | `string`       | No       | For an existing Managed Identity, the Subscription Id it is located in                                                                                         |
| `existingManagedIdentityResourceGroupName`       | `string`       | No       | For an existing Managed Identity, the Resource Group it is located in                                                                                          |
| `isApp`                                          | `bool`         | No       | Set to false to deploy from as an ARM template for debugging                                                                                                   |
| `keyVaultTags`                                   | `object`       | No       | Set tags to apply to Key Vault resources                                                                                                                       |
| `namespacesToReplicate`                          | `array`        | No       | Array of ddc namespaces to replicate if there are secondary regions                                                                                            |
| `newOrExistingWorkspaceForContainerInsights`     | `string`       | No       | If new or existing, this will enable container insights on the AKS cluster. If new, will create one log analytics workspace per location                       |
| `logAnalyticsWorkspaceName`                      | `string`       | No       | The name of the log analytics workspace to use for container insights                                                                                          |
| `existingLogAnalyticsWorkspaceResourceGroupName` | `string`       | No       | The resource group corresponding to an existing logAnalyticsWorkspaceName                                                                                      |

## Outputs

| Name                  | Type   | Description                        |
| :-------------------- | :----: | :--------------------------------- |
| cosmosDBName          | string | Name of Cosmos DB resource         |
| newOrExistingCosmosDB | string | New or Existing Cosmos DB resource |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```
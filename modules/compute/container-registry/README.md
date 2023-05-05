# Container Registry

This module deploys Container Registry (Microsoft.ContainerRegistry/registries) and optionally available integrations.

## Description

[Azure Container Registry (ACR)](http://aka.ms/acr) is a hosted registry for Docker and Open Container Initiative (OCI) artifacts. This module provides an Infrastructure as Code alternative for management of Container Registry using Bicep, and is intended to mirror the available functionality of provisioning with Azure Portal or CLI.

## Parameters

| Name                                    | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                     |
| :-------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `name`                                  | `string` | Yes      | The name of the Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                                                       |
| `location`                              | `string` | No       | Location for all resources.                                                                                                                                                                                                                                                                                                                                                                                                     |
| `tags`                                  | `object` | No       | Tags for all resource(s).                                                                                                                                                                                                                                                                                                                                                                                                       |
| `skuName`                               | `string` | No       | The SKU of the Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                                                        |
| `adminUserEnabled`                      | `bool`   | No       | Toggle the Azure Container Registry admin user.                                                                                                                                                                                                                                                                                                                                                                                 |
| `publicNetworkAccessEnabled`            | `bool`   | No       | Toggle public network access to Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                                       |
| `publicAzureAccessEnabled`              | `bool`   | No       | When public network access is disabled, toggle this to allow Azure services to bypass the public network access rule.                                                                                                                                                                                                                                                                                                           |
| `networkAllowedIpRanges`                | `array`  | No       | A list of IP or IP ranges in CIDR format, that should be allowed access to Azure Container Registry.                                                                                                                                                                                                                                                                                                                            |
| `networkDefaultAction`                  | `string` | No       | The default action to take when no network rule match is found for accessing Azure Container Registry.                                                                                                                                                                                                                                                                                                                          |
| `roleAssignments`                       | `array`  | No       | Array of role assignment objects that contain the 'roleDefinitionIdOrName'(string) and 'principalIds'(array of strings) to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `lock`                                  | `string` | No       | Specify the type of lock.                                                                                                                                                                                                                                                                                                                                                                                                       |
| `privateEndpoints`                      | `array`  | No       | Define Private Endpoints that should be created for Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                   |
| `privateEndpointsApprovalEnabled`       | `bool`   | No       | Toggle if Private Endpoints manual approval for Azure Container Registry should be enabled.                                                                                                                                                                                                                                                                                                                                     |
| `zoneRedundancyEnabled`                 | `bool`   | No       | Toggle if Zone Redundancy should be enabled on Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                        |
| `replicationLocations`                  | `array`  | No       | Array of Azure Location configurations that this Azure Container Registry should replicate too.                                                                                                                                                                                                                                                                                                                                 |
| `dataEndpointEnabled`                   | `bool`   | No       | Toggle if a single data endpoint per region for serving data from Azure Container Registry should be enabled.                                                                                                                                                                                                                                                                                                                   |
| `encryptionEnabled`                     | `bool`   | No       | Toggle if encryption should be enabled on Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                             |
| `exportPolicyEnabled`                   | `bool`   | No       | Toggle if export policy should be enabled on Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                          |
| `quarantinePolicyEnabled`               | `bool`   | No       | Toggle if quarantine policy should be enabled on Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                      |
| `retentionPolicyEnabled`                | `bool`   | No       | Toggle if retention policy should be enabled on Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                       |
| `retentionPolicyInDays`                 | `int`    | No       | Configure the retention policy in days for Azure Container Registry. Only effective is 'retentionPolicyEnabled' is 'true'.                                                                                                                                                                                                                                                                                                      |
| `trustPolicyEnabled`                    | `bool`   | No       | Toggle if trust policy should be enabled on Azure Container Registry.                                                                                                                                                                                                                                                                                                                                                           |
| `encryptionKeyVaultIdentity`            | `string` | No       | The client ID of the identity which will be used to access Key Vault.                                                                                                                                                                                                                                                                                                                                                           |
| `encryptionKeyVaultKeyIdentifier`       | `string` | No       | The Key Vault URI to access the encryption key.                                                                                                                                                                                                                                                                                                                                                                                 |
| `diagnosticLogsRetentionInDays`         | `int`    | No       | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.                                                                                                                                                                                                                                                                                                                            |
| `diagnosticStorageAccountId`            | `string` | No       | Resource ID of the diagnostic storage account.                                                                                                                                                                                                                                                                                                                                                                                  |
| `diagnosticWorkspaceId`                 | `string` | No       | Resource ID of the diagnostic log analytics workspace.                                                                                                                                                                                                                                                                                                                                                                          |
| `diagnosticEventHubAuthorizationRuleId` | `string` | No       | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.                                                                                                                                                                                                                                                                                |
| `diagnosticEventHubName`                | `string` | No       | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.                                                                                                                                                                                                                                                                                  |
| `logsToEnable`                          | `array`  | No       | The name of logs that will be streamed.                                                                                                                                                                                                                                                                                                                                                                                         |
| `metricsToEnable`                       | `array`  | No       | The name of metrics that will be streamed.                                                                                                                                                                                                                                                                                                                                                                                      |

## Outputs

| Name              | Type   | Description                                                        |
| :---------------- | :----: | :----------------------------------------------------------------- |
| resourceGroupName | string | The resource group the Azure Container Registry was deployed into. |
| resourceId        | string | The resource ID of the Azure Container Registry.                   |
| name              | string | The name of the Azure Container Registry.                          |
| loginServer       | string | The login server URL of the Azure Container Registry.              |

## Examples

### Example 1

An example of how to deploy Azure Container Registry using the minimum required parameters.

```bicep
module containerRegistry 'br/public:compute/container-registry:1.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-container-registry'
  params: {
    name: 'acr${uniqueString(deployment().name, location)}'
    location: 'eastus'
  }
}
```

### Example 2

An example of how to deploy a 'Premium' SKU instance of Azure Container Registry with private networking.

```bicep
param subnetId string
param privateDnsZoneId string

module containerRegistry 'br/public:compute/container-registry:1.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-container-registry'
  params: {
    name: 'acr${uniqueString(deployment().name, location)}'
    location: 'eastus'
    skuName: 'Premium'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: subnetId
        privateDnsZoneId: privateDnsZoneId
      }
    ]
  }
}
```

### Example 3

An example of how to deploy a 'Premium' SKU instance of Azure Container Registry with replication to multiple Azure Locations.

```bicep
module containerRegistry 'br/public:compute/container-registry:1.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-container-registry'
  params: {
    name: 'acr${uniqueString(deployment().name, location)}'
    location: 'eastus'
    skuName: 'Premium'
    replicationLocations: [
      {
        location: 'eastus2'
      }
      {
        location: 'northeurope'
        regionEndpointEnabled: true
        zoneRedundancy: true
      }
    ]
  }
}
```
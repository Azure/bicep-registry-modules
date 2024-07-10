# container-job `[App/ContainerJob]`

This module deploys a container to run as a job.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/jobs` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-05-01/jobs) |
| `Microsoft.App/managedEnvironments` | [2023-11-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-11-02-preview/managedEnvironments) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/virtualNetworks` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/app/container-job:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Align to WAG](#example-2-align-to-wag)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module containerJob 'br/public:avm/ptn/app/container-job:<version>' = {
  name: 'containerJobDeployment'
  params: {
    // Required parameters
    containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'acjmin001'
    // Non-required parameters
    location: '<location>'
    overwriteExistingImage: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "containerImageSource": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "acjmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "overwriteExistingImage": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 2: _Align to WAG_

This instance deploys the module with private networking.


<details>

<summary>via Bicep module</summary>

```bicep
module containerJob 'br/public:avm/ptn/app/container-job:<version>' = {
  name: 'containerJobDeployment'
  params: {
    // Required parameters
    containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'acjwaf001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "containerImageSource": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "acjwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerImageSource`](#parameter-containerimagesource) | string | The container image source that will be copied to the Container Registry and used to provision the job. |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-addressprefix) | string | The address prefix for the virtual network needs to be at least a /16. Required if `deployInVnet` is `true`. |
| [`deployDnsZoneContainerRegistry`](#parameter-deploydnszonecontainerregistry) | bool | A new private DNS Zone will be created. Required if `deployInVnet` is `true`. |
| [`deployDnsZoneKeyVault`](#parameter-deploydnszonekeyvault) | bool | A new private DNS Zone will be created. Required if `deployInVnet` is `true`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | string | The connection string for the Application Insights instance that will be added to Key Vault as `applicationinsights-connection-string` and can be used by the Job. |
| [`cpu`](#parameter-cpu) | string | The CPU resources that will be allocated to the Container Apps Job. |
| [`cronExpression`](#parameter-cronexpression) | string | The cron expression that will be used to schedule the job. |
| [`deployInVnet`](#parameter-deployinvnet) | bool | Deploy resources in a virtual network and use it for private endpoints. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`jobEnvironmentVariables`](#parameter-jobenvironmentvariables) | array | The environment variables that will be added to the Container Apps Job. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created. |
| [`managedIdentityName`](#parameter-managedidentityname) | string | Use an existing managed identity to import the container image and run the job. If not provided, a new managed identity will be created. |
| [`memory`](#parameter-memory) | string | The memory resources that will be allocated to the Container Apps Job. |
| [`nameSuffix`](#parameter-namesuffix) | string | The suffix will be used for newly created resources. |
| [`overwriteExistingImage`](#parameter-overwriteexistingimage) | bool | The flag that indicates whether the existing image in the Container Registry should be overwritten. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `containerImageSource`

The container image source that will be copied to the Container Registry and used to provision the job.

- Required: Yes
- Type: string
- Example: `mcr.microsoft.com/k8se/quickstart-jobs:latest`

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `addressPrefix`

The address prefix for the virtual network needs to be at least a /16. Required if `deployInVnet` is `true`.

- Required: No
- Type: string

### Parameter: `deployDnsZoneContainerRegistry`

A new private DNS Zone will be created. Required if `deployInVnet` is `true`.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `deployDnsZoneKeyVault`

A new private DNS Zone will be created. Required if `deployInVnet` is `true`.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `appInsightsConnectionString`

The connection string for the Application Insights instance that will be added to Key Vault as `applicationinsights-connection-string` and can be used by the Job.

- Required: No
- Type: string
- Example: `InstrumentationKey=<00000000-0000-0000-0000-000000000000>;IngestionEndpoint=https://germanywestcentral-1.in.applicationinsights.azure.com/;LiveEndpoint=https://germanywestcentral.livediagnostics.monitor.azure.com/;ApplicationId=<00000000-0000-0000-0000-000000000000>`

### Parameter: `cpu`

The CPU resources that will be allocated to the Container Apps Job.

- Required: No
- Type: string
- Default: `'1'`

### Parameter: `cronExpression`

The cron expression that will be used to schedule the job.

- Required: No
- Type: string
- Default: `'0 0 * * *'`

### Parameter: `deployInVnet`

Deploy resources in a virtual network and use it for private endpoints.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `jobEnvironmentVariables`

The environment variables that will be added to the Container Apps Job.

- Required: No
- Type: array
- Default: `[]`
- Example:
  ```Bicep
  [[
    {
      name: 'ENV_VAR_NAME'
      value: 'ENV_VAR_VALUE'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      secretRef: 'applicationinsights-connection-string'
    }
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsWorkspaceResourceId`

The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.

- Required: Yes
- Type: string
- Example: `/subscriptions/<00000000-0000-0000-0000-000000000000>/resourceGroups/<rg-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>`

### Parameter: `managedIdentityName`

Use an existing managed identity to import the container image and run the job. If not provided, a new managed identity will be created.

- Required: No
- Type: string

### Parameter: `memory`

The memory resources that will be allocated to the Container Apps Job.

- Required: No
- Type: string
- Default: `'2Gi'`

### Parameter: `nameSuffix`

The suffix will be used for newly created resources.

- Required: No
- Type: string
- Default: `'cjob'`

### Parameter: `overwriteExistingImage`

The flag that indicates whether the existing image in the Container Registry should be overwritten.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      "key1": "value1"
      "key2": "value2"
  }
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the container job. |
| `resourceGroupName` | string | The name of the Resource Group the resource was deployed into. |
| `resourceId` | string | The resource ID of the container job. |
| `vnetResourceId` | string | Conditional. The virtual network resourceId, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/deployment-script/import-image-to-acr:0.1.0` | Remote reference |
| `br/public:avm/res/app/job:0.1.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.5.2` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.3.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.6.2` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.2.2` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.3.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.3.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.4.2` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.8` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.9.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

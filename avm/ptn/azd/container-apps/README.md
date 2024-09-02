# avm/ptn/azd/container-apps `[Azd/ContainerApps]`

Creates an Azure Container Registry and an Azure Container Apps environment.

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
| `Microsoft.App/managedEnvironments` | [2024-02-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-02-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/storages` | [2024-02-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-02-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/container-apps:<version>`.

- [Using default parameter set](#example-1-using-default-parameter-set)

### Example 1: _Using default parameter set_

This instance deploys the module with default parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module containerApps 'br/public:avm/ptn/azd/container-apps:<version>' = {
  name: 'containerAppsDeployment'
  params: {
    // Required parameters
    containerAppsEnvironmentName: 'container-apps-environment-casmin'
    containerRegistryName: 'container-registry-casmin'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
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
    "containerAppsEnvironmentName": {
      "value": "container-apps-environment-casmin"
    },
    "containerRegistryName": {
      "value": "container-registry-casmin"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
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
| [`containerAppsEnvironmentName`](#parameter-containerappsenvironmentname) | string | Name of the Container Apps Managed Environment. |
| [`containerRegistryName`](#parameter-containerregistryname) | string | Name of the Azure Container Registry. |
| [`containerRegistryResourceGroupName`](#parameter-containerregistryresourcegroupname) | string | Name of the Azure Container Registry Resource Group. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrAdminUserEnabled`](#parameter-acradminuserenabled) | bool | Enable admin user that have push / pull permission to the registry. |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | securestring | Application Insights connection string. |
| [`daprAIInstrumentationKey`](#parameter-dapraiinstrumentationkey) | securestring | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `containerAppsEnvironmentName`

Name of the Container Apps Managed Environment.

- Required: Yes
- Type: string

### Parameter: `containerRegistryName`

Name of the Azure Container Registry.

- Required: Yes
- Type: string

### Parameter: `containerRegistryResourceGroupName`

Name of the Azure Container Registry Resource Group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `logAnalyticsWorkspaceResourceId`

Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).

- Required: Yes
- Type: string

### Parameter: `acrAdminUserEnabled`

Enable admin user that have push / pull permission to the registry.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `appInsightsConnectionString`

Application Insights connection string.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIInstrumentationKey`

Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultDomain` | string | The Default domain of the Managed Environment. |
| `environmentId` | string | The resource ID of the Managed Environment. |
| `environmentName` | string | The name of the Managed Environment. |
| `registryLoginServer` | string | The reference to the Azure container registry. |
| `registryName` | string | The Name of the Azure container registry. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/app/managed-environment:0.7.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

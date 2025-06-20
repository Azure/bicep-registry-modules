# Content Processing Solution Accelerator `[Sa/ContentProcessing]`

Bicep template to deploy the Content Processing Solution Accelerator with AVM compliance.

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
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials) |
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
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/virtualNetworks` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.SecurityInsights/onboardingStates` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/content-processing:<version>`.

- [main configuration with default parameter values](#example-1-main-configuration-with-default-parameter-values)
- [waf-aligned configuration with default parameter values](#example-2-waf-aligned-configuration-with-default-parameter-values)

### Example 1: _main configuration with default parameter values_

This instance deploys the [Content Processing Solution Accelerator] using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.


<details>

<summary>via Bicep module</summary>

```bicep
module contentProcessing 'br/public:avm/ptn/sa/content-processing:<version>' = {
  name: 'contentProcessingDeployment'
  params: {
    // Required parameters
    contentUnderstandingLocation: '<contentUnderstandingLocation>'
    environmentName: 'scpmin'
    gptDeploymentCapacity: 80
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "contentUnderstandingLocation": {
      "value": "<contentUnderstandingLocation>"
    },
    "environmentName": {
      "value": "scpmin"
    },
    "gptDeploymentCapacity": {
      "value": 80
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/content-processing:<version>'

// Required parameters
param contentUnderstandingLocation = '<contentUnderstandingLocation>'
param environmentName = 'scpmin'
param gptDeploymentCapacity = 80
```

</details>
<p>

### Example 2: _waf-aligned configuration with default parameter values_

This instance deploys the [Content Processing Solution Accelerator]


<details>

<summary>via Bicep module</summary>

```bicep
module contentProcessing 'br/public:avm/ptn/sa/content-processing:<version>' = {
  name: 'contentProcessingDeployment'
  params: {
    // Required parameters
    contentUnderstandingLocation: '<contentUnderstandingLocation>'
    environmentName: 'scpwaf'
    gptDeploymentCapacity: 80
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "contentUnderstandingLocation": {
      "value": "<contentUnderstandingLocation>"
    },
    "environmentName": {
      "value": "scpwaf"
    },
    "gptDeploymentCapacity": {
      "value": 80
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/content-processing:<version>'

// Required parameters
param contentUnderstandingLocation = '<contentUnderstandingLocation>'
param environmentName = 'scpwaf'
param gptDeploymentCapacity = 80
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentUnderstandingLocation`](#parameter-contentunderstandinglocation) | string | Location for the content understanding service: WestUS | SwedenCentral | AustraliaEast. |
| [`environmentName`](#parameter-environmentname) | string | Name of the environment to deploy the solution into. |
| [`gptDeploymentCapacity`](#parameter-gptdeploymentcapacity) | int | Capacity of the GPT deployment: (minimum 10). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploymentType`](#parameter-deploymenttype) | string | Type of GPT deployment to use: Standard | GlobalStandard. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Enable WAF for the deployment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gptModelName`](#parameter-gptmodelname) | string | Name of the GPT model to deploy: gpt-4o-mini | gpt-4o | gpt-4. |
| [`gptModelVersion`](#parameter-gptmodelversion) | string | Version of the GPT model to deploy:. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`publicContainerImageEndpoint`](#parameter-publiccontainerimageendpoint) | string | The public container image endpoint. |
| [`resourceGroupLocation`](#parameter-resourcegrouplocation) | string | The resource group location. |
| [`resourceNameFormatString`](#parameter-resourcenameformatstring) | string | The resource name format string. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |
| [`useLocalBuild`](#parameter-uselocalbuild) | bool | Set to true to use local build for container app images, otherwise use container registry images. |

### Parameter: `contentUnderstandingLocation`

Location for the content understanding service: WestUS | SwedenCentral | AustraliaEast.

- Required: Yes
- Type: string

### Parameter: `environmentName`

Name of the environment to deploy the solution into.

- Required: Yes
- Type: string

### Parameter: `gptDeploymentCapacity`

Capacity of the GPT deployment: (minimum 10).

- Required: Yes
- Type: int
- MinValue: 10

### Parameter: `deploymentType`

Type of GPT deployment to use: Standard | GlobalStandard.

- Required: No
- Type: string
- Default: `'GlobalStandard'`

### Parameter: `enablePrivateNetworking`

Enable WAF for the deployment.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gptModelName`

Name of the GPT model to deploy: gpt-4o-mini | gpt-4o | gpt-4.

- Required: No
- Type: string
- Default: `'gpt-4o'`

### Parameter: `gptModelVersion`

Version of the GPT model to deploy:.

- Required: No
- Type: string
- Default: `'2024-08-06'`
- Allowed:
  ```Bicep
  [
    '2024-08-06'
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `publicContainerImageEndpoint`

The public container image endpoint.

- Required: No
- Type: string
- Default: `'cpscontainerreg.azurecr.io'`

### Parameter: `resourceGroupLocation`

The resource group location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `resourceNameFormatString`

The resource name format string.

- Required: No
- Type: string
- Default: `'{0}avm-cps'`

### Parameter: `tags`

Tags to be applied to the resources.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      app: 'Content Processing Solution Accelerator'
      location: '[resourceGroup().location]'
  }
  ```

### Parameter: `useLocalBuild`

Set to true to use local build for container app images, otherwise use container registry images.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The resource group the resources were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.1` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.7.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.11.2` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

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

- [With zoneRedundant enabled](#example-1-with-zoneredundant-enabled)

### Example 1: _With zoneRedundant enabled_

This instance deploys the module with zoneRedundant enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module containerApps 'br/public:avm/ptn/azd/container-apps:<version>' = {
  name: 'containerAppsDeployment'
  params: {
    // Required parameters
    containerAppsEnvironmentName: 'acazrcae001'
    containerRegistryName: 'acazrcr001'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    acrSku: 'Standard'
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    location: '<location>'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
      }
    ]
    zoneRedundant: true
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
      "value": "acazrcae001"
    },
    "containerRegistryName": {
      "value": "acazrcr001"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Standard"
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
        }
      ]
    },
    "zoneRedundant": {
      "value": true
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
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dockerBridgeCidr`](#parameter-dockerbridgecidr) | string | CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureSubnetResourceId`](#parameter-infrastructuresubnetresourceid) | string | Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`internal`](#parameter-internal) | bool | Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`platformReservedCidr`](#parameter-platformreservedcidr) | string | IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant. |
| [`platformReservedDnsIP`](#parameter-platformreserveddnsip) | string | An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`workloadProfiles`](#parameter-workloadprofiles) | array | Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrAdminUserEnabled`](#parameter-acradminuserenabled) | bool | Enable admin user that have push / pull permission to the registry. |
| [`acrSku`](#parameter-acrsku) | string | SKU settings. Default is "Standard". |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | securestring | Application Insights connection string. |
| [`containerRegistryResourceGroupName`](#parameter-containerregistryresourcegroupname) | string | Name of the Azure Container Registry Resource Group. |
| [`daprAIInstrumentationKey`](#parameter-dapraiinstrumentationkey) | securestring | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`infrastructureResourceGroupName`](#parameter-infrastructureresourcegroupname) | string | Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Zone redundancy setting. |

### Parameter: `containerAppsEnvironmentName`

Name of the Container Apps Managed Environment.

- Required: Yes
- Type: string

### Parameter: `containerRegistryName`

Name of the Azure Container Registry.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceResourceId`

Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).

- Required: Yes
- Type: string

### Parameter: `dockerBridgeCidr`

CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `infrastructureSubnetResourceId`

Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `internal`

Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `platformReservedCidr`

IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `platformReservedDnsIP`

An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `workloadProfiles`

Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `acrAdminUserEnabled`

Enable admin user that have push / pull permission to the registry.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `acrSku`

SKU settings. Default is "Standard".

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `appInsightsConnectionString`

Application Insights connection string.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `containerRegistryResourceGroupName`

Name of the Azure Container Registry Resource Group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `daprAIInstrumentationKey`

Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `infrastructureResourceGroupName`

Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `[take(format('ME_{0}', parameters('containerAppsEnvironmentName')), 63)]`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneRedundant`

Zone redundancy setting.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultDomain` | string | The Default domain of the Managed Environment. |
| `environmentName` | string | The name of the Managed Environment. |
| `environmentResourceId` | string | The resource ID of the Managed Environment. |
| `registryLoginServer` | string | The reference to the Azure container registry. |
| `registryName` | string | The Name of the Azure container registry. |
| `resourceGroupName` | string | The name of the resource group the all resources was deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/app/managed-environment:0.7.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

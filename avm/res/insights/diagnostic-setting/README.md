# Diagnostic Settings (Activity Logs) for Azure Subscriptions `[Microsoft.Insights/diagnosticSettings]`

This module deploys a Subscription wide export of the Activity Log.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/diagnostic-setting:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module diagnosticSetting 'br/public:avm/res/insights/diagnostic-setting:<version>' = {
  name: 'diagnosticSettingDeployment'
  params: {
    location: '<location>'
    name: 'idsmin001'
    workspaceResourceId: '<workspaceResourceId>'
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
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "idsmin001"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module diagnosticSetting 'br/public:avm/res/insights/diagnostic-setting:<version>' = {
  name: 'diagnosticSettingDeployment'
  params: {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    location: '<location>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'idsmax001'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
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
    "eventHubAuthorizationRuleResourceId": {
      "value": "<eventHubAuthorizationRuleResourceId>"
    },
    "eventHubName": {
      "value": "<eventHubName>"
    },
    "location": {
      "value": "<location>"
    },
    "metricCategories": {
      "value": [
        {
          "category": "AllMetrics"
        }
      ]
    },
    "name": {
      "value": "idsmax001"
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module diagnosticSetting 'br/public:avm/res/insights/diagnostic-setting:<version>' = {
  name: 'diagnosticSettingDeployment'
  params: {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    location: '<location>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'idswaf001'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
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
    "eventHubAuthorizationRuleResourceId": {
      "value": "<eventHubAuthorizationRuleResourceId>"
    },
    "eventHubName": {
      "value": "<eventHubName>"
    },
    "location": {
      "value": "<location>"
    },
    "metricCategories": {
      "value": [
        {
          "category": "AllMetrics"
        }
      ]
    },
    "name": {
      "value": "idswaf001"
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    }
  }
}
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`eventHubAuthorizationRuleResourceId`](#parameter-eventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-eventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`logAnalyticsDestinationType`](#parameter-loganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-logcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-marketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-metriccategories) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`name`](#parameter-name) | string | Name of the Diagnostic settings. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Resource ID of the diagnostic storage account. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. |

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.

- Required: No
- Type: string

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-logcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-logcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `AllLogs` to collect all logs. |
| [`enabled`](#parameter-logcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `AllLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `metricCategories`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-metriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-metriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `name`

Name of the Diagnostic settings.

- Required: No
- Type: string
- Default: `[format('{0}-diagnosticSettings', uniqueString(subscription().id))]`

### Parameter: `storageAccountResourceId`

Resource ID of the diagnostic storage account.

- Required: No
- Type: string

### Parameter: `workspaceResourceId`

Resource ID of the diagnostic log analytics workspace.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the diagnostic settings. |
| `resourceId` | string | The resource ID of the diagnostic settings. |
| `subscriptionName` | string | The name of the subscription to deploy into. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

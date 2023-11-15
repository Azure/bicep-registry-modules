# Diagnostic Settings (Activity Logs) for Azure Subscriptions `[Microsoft.Insights/diagnosticSettings]`

This module deploys a Subscription wide export of the Activity Log.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/insights.diagnostic-setting:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module diagnosticSetting 'br:bicep/modules/insights.diagnostic-setting:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idsmax'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "eventHubAuthorizationRuleResourceId": {
      "value": "<eventHubAuthorizationRuleResourceId>"
    },
    "eventHubName": {
      "value": "<eventHubName>"
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

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module diagnosticSetting 'br:bicep/modules/insights.diagnostic-setting:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idswaf'
  params: {
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "eventHubAuthorizationRuleResourceId": {
      "value": "<eventHubAuthorizationRuleResourceId>"
    },
    "eventHubName": {
      "value": "<eventHubName>"
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
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`eventHubAuthorizationRuleResourceId`](#parameter-eventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-eventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`logAnalyticsDestinationType`](#parameter-loganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-logcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-marketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-metriccategories) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-name) | string | Name of the Diagnostic settings. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Resource ID of the diagnostic storage account. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
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

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-logcategoriesandgroupscategory) | No | string | Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-logcategoriesandgroupscategorygroup) | No | string | Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `logCategoriesAndGroups.category`

Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `logCategoriesAndGroups.categoryGroup`

Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string

### Parameter: `marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.
- Required: No
- Type: string

### Parameter: `metricCategories`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-metriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics. |

### Parameter: `metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics.

- Required: Yes
- Type: string

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

## Cross-referenced modules

_None_

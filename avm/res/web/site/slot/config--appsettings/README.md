# Site Slot App Settings `[Microsoft.Web/sites/slots/config]`

This module deploys a Site Slot App Setting.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/slots/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Type of slot to deploy. |
| [`slotName`](#parameter-slotname) | string | Slot name to be configured. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightResourceId`](#parameter-appinsightresourceid) | string | Resource ID of the app insight to leverage for this resource. |
| [`appSettingsKeyValuePairs`](#parameter-appsettingskeyvaluepairs) | object | The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`setAzureWebJobsDashboard`](#parameter-setazurewebjobsdashboard) | bool | For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |

### Parameter: `kind`

Type of slot to deploy.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'app'
    'functionapp'
    'functionapp,linux'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
  ]
  ```

### Parameter: `slotName`

Slot name to be configured.

- Required: Yes
- Type: string

### Parameter: `appName`

The name of the parent site resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `appInsightResourceId`

Resource ID of the app insight to leverage for this resource.

- Required: No
- Type: string
- Default: `''`

### Parameter: `appSettingsKeyValuePairs`

The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `setAzureWebJobsDashboard`

For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons.

- Required: No
- Type: bool
- Default: `[if(contains(parameters('kind'), 'functionapp'), true(), false())]`

### Parameter: `storageAccountResourceId`

Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the slot config. |
| `resourceGroupName` | string | The resource group the slot config was deployed into. |
| `resourceId` | string | The resource ID of the slot config. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": {
      "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
      "EASYAUTH_SECRET": "https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
      "FUNCTIONS_EXTENSION_VERSION": "~4",
      "FUNCTIONS_WORKER_RUNTIME": "dotnet"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  EASYAUTH_SECRET: 'https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

</details>
<p>

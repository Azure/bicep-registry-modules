# Site Slot App Settings `[Microsoft.Web/sites/slots/config]`

This module deploys a Site Slot App Setting.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/slots/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/config) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Type of site to deploy. |
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
| [`currentAppSettings`](#parameter-currentappsettings) | object | The current app settings. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| [`storageAccountUseIdentityAuthentication`](#parameter-storageaccountuseidentityauthentication) | bool | If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'. |

### Parameter: `kind`

Type of site to deploy.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'api'
    'app'
    'app,container,windows'
    'app,linux'
    'app,linux,container'
    'functionapp'
    'functionapp,linux'
    'functionapp,linux,container'
    'functionapp,linux,container,azurecontainerapps'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
    'linux,api'
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

### Parameter: `appSettingsKeyValuePairs`

The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.

- Required: No
- Type: object

### Parameter: `currentAppSettings`

The current app settings.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `storageAccountResourceId`

Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.

- Required: No
- Type: string

### Parameter: `storageAccountUseIdentityAuthentication`

If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the slot config. |
| `resourceGroupName` | string | The resource group the slot config was deployed into. |
| `resourceId` | string | The resource ID of the slot config. |

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
      "EASYAUTH_SECRET": "https://adp-#_namePrefix_#-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
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
  EASYAUTH_SECRET: 'https://adp-#_namePrefix_#-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

</details>
<p>

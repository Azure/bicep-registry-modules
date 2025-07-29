# Site App Settings `[Microsoft.Web/sites/slots/config]`

This module deploys a Site App Setting.

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
| [`name`](#parameter-name) | string | The name of the config. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |
| [`slotName`](#parameter-slotname) | string | The name of the parent web site slot. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightResourceId`](#parameter-applicationinsightresourceid) | string | Resource ID of the application insight to leverage for this resource. |
| [`currentAppSettings`](#parameter-currentappsettings) | object | The current app settings. |
| [`properties`](#parameter-properties) | object | The properties of the config. Note: This parameter is highly dependent on the config type, defined by its name. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| [`storageAccountUseIdentityAuthentication`](#parameter-storageaccountuseidentityauthentication) | bool | If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'. |

### Parameter: `name`

The name of the config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'appsettings'
    'authsettings'
    'authsettingsV2'
    'azurestorageaccounts'
    'backup'
    'connectionstrings'
    'logs'
    'metadata'
    'pushsettings'
    'web'
  ]
  ```

### Parameter: `appName`

The name of the parent site resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `slotName`

The name of the parent web site slot. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `applicationInsightResourceId`

Resource ID of the application insight to leverage for this resource.

- Required: No
- Type: string

### Parameter: `currentAppSettings`

The current app settings.

- Required: No
- Type: object
- Default: `{}`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-currentappsettings>any_other_property<) | string | The key-values pairs of the current app settings. |

### Parameter: `currentAppSettings.>Any_other_property<`

The key-values pairs of the current app settings.

- Required: Yes
- Type: string

### Parameter: `properties`

The properties of the config. Note: This parameter is highly dependent on the config type, defined by its name.

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
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |

## Notes

### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": [
        {
            "name": "key1",
            "value": "val1"
        },
        {
            "name": "key2",
            "value": "val2"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: [
    {
        name: 'key1'
        value: 'val1'
    }
    {
        name: 'key2'
        value: 'val2'
    }
]
```

</details>
<p>

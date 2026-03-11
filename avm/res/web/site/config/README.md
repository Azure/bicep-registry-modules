# Site App Settings `[Microsoft.Web/sites/config]`

This module deploys a Site App Setting.

You can reference the module as follows:
```bicep
module site 'br/public:avm/res/web/site/config:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Web/sites/config` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/config)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the config. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightResourceId`](#parameter-applicationinsightresourceid) | string | Resource ID of the application insight to leverage for this resource. |
| [`currentAppSettings`](#parameter-currentappsettings) | object | The current app settings. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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
    'slotConfigNames'
    'web'
  ]
  ```

### Parameter: `appName`

The name of the parent site resource. Required if the template is used in a standalone deployment.

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

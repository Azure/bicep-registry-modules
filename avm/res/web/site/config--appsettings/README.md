# Site App Settings `[Microsoft.Web/sites/config]`

This module deploys a Site App Setting.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Type of site to deploy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightResourceId`](#parameter-appinsightresourceid) | string | Resource ID of the app insight to leverage for this resource. |
| [`appSettingsKeyValuePairs`](#parameter-appsettingskeyvaluepairs) | object | The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| [`setAzureWebJobsDashboard`](#parameter-setazurewebjobsdashboard) | bool | For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |

### Parameter: `kind`

Type of site to deploy.

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

### Parameter: `setAzureWebJobsDashboard`

For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons.

- Required: No
- Type: bool
- Default: `[if(contains(parameters('kind'), 'functionapp'), true(), false())]`

### Parameter: `storageAccountResourceId`

Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.

- Required: No
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |

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

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

# Log Analytics Workspace Saved Searches `[Microsoft.OperationalInsights/workspaces/savedSearches]`

This module deploys a Log Analytics Workspace Saved Search.

You can reference the module as follows:
```bicep
module workspace 'br/public:avm/res/operational-insights/workspace/saved-search:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_savedsearches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/savedSearches)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-category) | string | Query category. |
| [`displayName`](#parameter-displayname) | string | Display name for the search. |
| [`name`](#parameter-name) | string | Name of the saved search. |
| [`query`](#parameter-query) | string | Kusto Query to be stored. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`etag`](#parameter-etag) | string | The ETag of the saved search. To override an existing saved search, use "*" or specify the current Etag. |
| [`functionAlias`](#parameter-functionalias) | string | The function alias if query serves as a function. |
| [`functionParameters`](#parameter-functionparameters) | string | The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions. |
| [`tags`](#parameter-tags) | array | Tags to configure in the resource. |
| [`version`](#parameter-version) | int | The version number of the query language. |

### Parameter: `category`

Query category.

- Required: Yes
- Type: string

### Parameter: `displayName`

Display name for the search.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the saved search.

- Required: Yes
- Type: string

### Parameter: `query`

Kusto Query to be stored.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `etag`

The ETag of the saved search. To override an existing saved search, use "*" or specify the current Etag.

- Required: No
- Type: string
- Default: `'*'`

### Parameter: `functionAlias`

The function alias if query serves as a function.

- Required: No
- Type: string
- Default: `''`

### Parameter: `functionParameters`

The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags to configure in the resource.

- Required: No
- Type: array

### Parameter: `version`

The version number of the query language.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed saved search. |
| `resourceGroupName` | string | The resource group where the saved search is deployed. |
| `resourceId` | string | The resource ID of the deployed saved search. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

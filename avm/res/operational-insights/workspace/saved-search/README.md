# Log Analytics Workspace Saved Searches `[Microsoft.OperationalInsights/workspaces/savedSearches]`

This module deploys a Log Analytics Workspace Saved Search.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |

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
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
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

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.
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

### Parameter: `tags`

Tags to configure in the resource.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `version`

The version number of the query language.
- Required: No
- Type: int
- Default: `2`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed saved search. |
| `resourceGroupName` | string | The resource group where the saved search is deployed. |
| `resourceId` | string | The resource ID of the deployed saved search. |

## Cross-referenced modules

_None_

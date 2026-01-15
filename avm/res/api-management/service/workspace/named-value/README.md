# API Management Workspace Named Values `[Microsoft.ApiManagement/service/workspaces/namedValues]`

This module deploys a Named Value in an API Management Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/workspaces/namedValues` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_namedvalues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/namedValues)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters. |
| [`name`](#parameter-name) | string | The name of the named value. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVault`](#parameter-keyvault) | object | KeyVault location details of the namedValue. |
| [`secret`](#parameter-secret) | bool | Determines whether the value is a secret and should be encrypted or not. |
| [`tags`](#parameter-tags) | array | Tags that when provided can be used to filter the NamedValue list. |
| [`value`](#parameter-value) | securestring | Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |

### Parameter: `displayName`

Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the named value.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `keyVault`

KeyVault location details of the namedValue.

- Required: No
- Type: object

### Parameter: `secret`

Determines whether the value is a secret and should be encrypted or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags that when provided can be used to filter the NamedValue list.

- Required: No
- Type: array

### Parameter: `value`

Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.

- Required: No
- Type: securestring
- Default: `[newGuid()]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the workspace named value. |
| `resourceGroupName` | string | The resource group the workspace named value was deployed into. |
| `resourceId` | string | The resource ID of the workspace named value. |

# API Management Service Portal Settings `[Microsoft.ApiManagement/service/portalsettings]`

This module deploys an API Management Service Portal Setting.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/portalsettings` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/service) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Portal setting name. |
| [`properties`](#parameter-properties) | object | Portal setting properties. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

### Parameter: `name`

Portal setting name.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'delegation'
    'signin'
    'signup'
  ]
  ```

### Parameter: `properties`

Portal setting properties.

- Required: Yes
- Type: object

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service portal setting. |
| `resourceGroupName` | string | The resource group the API management service portal setting was deployed into. |
| `resourceId` | string | The resource ID of the API management service portal setting. |

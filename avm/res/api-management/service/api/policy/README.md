# API Management Service APIs Policies `[Microsoft.ApiManagement/service/apis/policies]`

This module deploys an API Management Service API Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/policies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-value) | string | Contents of the Policy as defined by the format. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-format) | string | Format of the policyContent. |
| [`name`](#parameter-name) | string | The name of the policy. |

### Parameter: `value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `apiName`

The name of the parent API. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `format`

Format of the policyContent.

- Required: No
- Type: string
- Default: `'xml'`
- Allowed:
  ```Bicep
  [
    'rawxml'
    'rawxml-link'
    'xml'
    'xml-link'
  ]
  ```

### Parameter: `name`

The name of the policy.

- Required: No
- Type: string
- Default: `'policy'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API policy. |
| `resourceGroupName` | string | The resource group the API policy was deployed into. |
| `resourceId` | string | The resource ID of the API policy. |

# API Management Service Policies `[Microsoft.ApiManagement/service/policies]`

This module deploys an API Management Service Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/policies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-value) | string | Contents of the Policy as defined by the format. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

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
| `name` | string | The name of the API management service policy. |
| `resourceGroupName` | string | The resource group the API management service policy was deployed into. |
| `resourceId` | string | The resource ID of the API management service policy. |

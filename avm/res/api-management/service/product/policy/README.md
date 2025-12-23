# API Management Service Product Policies `[Microsoft.ApiManagement/service/products/policies]`

This module deploys an API Management Service Product Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/products/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_products_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/products/policies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-value) | string | Contents of the Policy as defined by the format. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`productName`](#parameter-productname) | string | The name of the parent product. Required if the template is used in a standalone deployment. |

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

### Parameter: `productName`

The name of the parent product. Required if the template is used in a standalone deployment.

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
| `name` | string | The name of the Product policy. |
| `resourceGroupName` | string | The resource group the Product policy was deployed into. |
| `resourceId` | string | The resource ID of the Product policy. |

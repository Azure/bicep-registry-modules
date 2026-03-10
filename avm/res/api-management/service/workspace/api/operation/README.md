# API Management Workspace API Operations `[Microsoft.ApiManagement/service/workspaces/apis/operations]`

This module deploys an API Operation under an API Management Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/workspaces/apis/operations` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_operations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/operations)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/operations/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_operations_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/operations/policies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the operation. |
| [`method`](#parameter-method) | string | A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them. |
| [`name`](#parameter-name) | string | The name of the operation. |
| [`urlTemplate`](#parameter-urltemplate) | string | Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`apiName`](#parameter-apiname) | string | The name of the parent API. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of the operation. May include HTML formatting tags. |
| [`policies`](#parameter-policies) | array | The policies to apply to the operation. |
| [`request`](#parameter-request) | object | An entity containing request details. |
| [`responses`](#parameter-responses) | array | An entity containing request details. |
| [`templateParameters`](#parameter-templateparameters) | array | Collection of URL template parameters. |

### Parameter: `displayName`

The display name of the operation.

- Required: Yes
- Type: string

### Parameter: `method`

A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the operation.

- Required: Yes
- Type: string

### Parameter: `urlTemplate`

Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}.

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

### Parameter: `workspaceName`

The name of the parent Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Description of the operation. May include HTML formatting tags.

- Required: No
- Type: string

### Parameter: `policies`

The policies to apply to the operation.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-policiesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-policiesformat) | string | Format of the policyContent. |
| [`name`](#parameter-policiesname) | string | The name of the policy. |

### Parameter: `policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `policies.format`

Format of the policyContent.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'rawxml'
    'rawxml-link'
    'xml'
    'xml-link'
  ]
  ```

### Parameter: `policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `request`

An entity containing request details.

- Required: No
- Type: object

### Parameter: `responses`

An entity containing request details.

- Required: No
- Type: array

### Parameter: `templateParameters`

Collection of URL template parameters.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the operation. |
| `resourceGroupName` | string | The resource group the operation was deployed into. |
| `resourceId` | string | The resource ID of the operation. |

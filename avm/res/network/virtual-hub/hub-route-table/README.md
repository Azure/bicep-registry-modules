# Virtual Hub Route Tables `[Microsoft.Network/virtualHubs/hubRouteTables]`

This module deploys a Virtual Hub Route Table.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/virtualHubs/hubRouteTables` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualhubs_hubroutetables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/virtualHubs/hubRouteTables)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The route table name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualHubName`](#parameter-virtualhubname) | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labels`](#parameter-labels) | array | List of labels associated with this route table. |
| [`routes`](#parameter-routes) | array | List of all routes. |

### Parameter: `name`

The route table name.

- Required: Yes
- Type: string

### Parameter: `virtualHubName`

The name of the parent virtual hub. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `labels`

List of labels associated with this route table.

- Required: No
- Type: array

### Parameter: `routes`

List of all routes.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual hub route table. |
| `resourceGroupName` | string | The resource group the virtual hub route table was deployed into. |
| `resourceId` | string | The resource ID of the deployed virtual hub route table. |

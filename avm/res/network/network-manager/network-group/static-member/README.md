# Network Manager Network Group Static Members `[Microsoft.Network/networkManagers/networkGroups/staticMembers]`

This module deploys a Network Manager Network Group Static Member.
Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/networkGroups/staticMembers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the static member. |
| [`resourceId`](#parameter-resourceid) | string | Resource ID of the virtual network. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkGroupName`](#parameter-networkgroupname) | string | The name of the parent network group. Required if the template is used in a standalone deployment. |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

### Parameter: `name`

The name of the static member.

- Required: Yes
- Type: string

### Parameter: `resourceId`

Resource ID of the virtual network.

- Required: Yes
- Type: string

### Parameter: `networkGroupName`

The name of the parent network group. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed static member. |
| `resourceGroupName` | string | The resource group the static member was deployed into. |
| `resourceId` | string | The resource ID of the deployed static member. |

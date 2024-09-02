# Network Manager Network Group Static Members `[Microsoft.Network/networkManagers/networkGroups/staticMembers]`

This module deploys a Network Manager Network Group Static Member.
Static membership allows you to explicitly add virtual networks to a group by manually selecting individual virtual networks.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

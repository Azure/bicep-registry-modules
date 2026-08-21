# Network Manager Network Groups `[Microsoft.Network/networkManagers/networkGroups]`

This module deploys a Network Manager Network Group.
A network group is a collection of same-type network resources that you can associate with network manager configurations. You can add same-type network resources after you create the network group.

You can reference the module as follows:
```bicep
module networkManager 'br/public:avm/res/network/network-manager/network-group:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/networkManagers/networkGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkmanagers_networkgroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/networkManagers/networkGroups)</li></ul> |
| `Microsoft.Network/networkManagers/networkGroups/staticMembers` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkmanagers_networkgroups_staticmembers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/networkManagers/networkGroups/staticMembers)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the network group. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the network group. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`memberType`](#parameter-membertype) | string | The type of the group member. Subnet member type is used for routing configurations. |
| [`staticMembers`](#parameter-staticmembers) | array | Static Members to create for the network group. Contains virtual networks to add to the network group. |

### Parameter: `name`

The name of the network group.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the network group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `memberType`

The type of the group member. Subnet member type is used for routing configurations.

- Required: No
- Type: string
- Default: `'VirtualNetwork'`

### Parameter: `staticMembers`

Static Members to create for the network group. Contains virtual networks to add to the network group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-staticmembersname) | string | The name of the static member. |
| [`resourceId`](#parameter-staticmembersresourceid) | string | Resource ID of the virtual network. |

### Parameter: `staticMembers.name`

The name of the static member.

- Required: Yes
- Type: string

### Parameter: `staticMembers.resourceId`

Resource ID of the virtual network.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed network group. |
| `resourceGroupName` | string | The resource group the network group was deployed into. |
| `resourceId` | string | The resource ID of the deployed network group. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

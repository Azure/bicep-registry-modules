# Network Manager Connectivity Configurations `[Microsoft.Network/networkManagers/connectivityConfigurations]`

This module deploys a Network Manager Connectivity Configuration.
Connectivity configurations define hub-and-spoke or mesh topologies applied to one or more network groups.

You can reference the module as follows:
```bicep
module networkManager 'br/public:avm/res/network/network-manager/connectivity-configuration:<version>' = {
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
| `Microsoft.Network/networkManagers/connectivityConfigurations` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkmanagers_connectivityconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/networkManagers/connectivityConfigurations)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesToGroups`](#parameter-appliestogroups) | array | Network Groups for the configuration. A connectivity configuration must be associated to at least one network group. |
| [`connectivityTopology`](#parameter-connectivitytopology) | string | Connectivity topology type. |
| [`name`](#parameter-name) | string | The name of the connectivity configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hubs`](#parameter-hubs) | array | List of hub items. This will create peerings between the specified hub and the virtual networks in the network group specified. Required if connectivityTopology is of type "HubAndSpoke". |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectivityCapabilities`](#parameter-connectivitycapabilities) | object | Collection of additional settings to enhance specific topology behaviors of the connectivity configuration, such as address overlap, private endpoint scale, and peering enforcement. |
| [`deleteExistingPeering`](#parameter-deleteexistingpeering) | bool | Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke". |
| [`description`](#parameter-description) | string | A description of the connectivity configuration. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`isGlobal`](#parameter-isglobal) | bool | Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions. |

### Parameter: `appliesToGroups`

Network Groups for the configuration. A connectivity configuration must be associated to at least one network group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupConnectivity`](#parameter-appliestogroupsgroupconnectivity) | string | Group connectivity type. |
| [`networkGroupResourceId`](#parameter-appliestogroupsnetworkgroupresourceid) | string | Resource Id of the network group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isGlobal`](#parameter-appliestogroupsisglobal) | bool | Flag if global is supported. |
| [`useHubGateway`](#parameter-appliestogroupsusehubgateway) | bool | Flag if use hub gateway. |

### Parameter: `appliesToGroups.groupConnectivity`

Group connectivity type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'DirectlyConnected'
    'None'
  ]
  ```

### Parameter: `appliesToGroups.networkGroupResourceId`

Resource Id of the network group.

- Required: Yes
- Type: string

### Parameter: `appliesToGroups.isGlobal`

Flag if global is supported.

- Required: No
- Type: bool

### Parameter: `appliesToGroups.useHubGateway`

Flag if use hub gateway.

- Required: No
- Type: bool

### Parameter: `connectivityTopology`

Connectivity topology type.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the connectivity configuration.

- Required: Yes
- Type: string

### Parameter: `hubs`

List of hub items. This will create peerings between the specified hub and the virtual networks in the network group specified. Required if connectivityTopology is of type "HubAndSpoke".

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-hubsresourceid) | string | Resource Id of the hub. |
| [`resourceType`](#parameter-hubsresourcetype) | string | Resource type of the hub. |

### Parameter: `hubs.resourceId`

Resource Id of the hub.

- Required: Yes
- Type: string

### Parameter: `hubs.resourceType`

Resource type of the hub.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Microsoft.Network/virtualNetworks'
  ]
  ```

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `connectivityCapabilities`

Collection of additional settings to enhance specific topology behaviors of the connectivity configuration, such as address overlap, private endpoint scale, and peering enforcement.

- Required: No
- Type: object

### Parameter: `deleteExistingPeering`

Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke".

- Required: No
- Type: bool
- Default: `False`

### Parameter: `description`

A description of the connectivity configuration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isGlobal`

Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed connectivity configuration. |
| `resourceGroupName` | string | The resource group the connectivity configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed connectivity configuration. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

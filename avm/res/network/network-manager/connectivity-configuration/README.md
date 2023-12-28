# Network Manager Connectivity Configurations `[Microsoft.Network/networkManagers/connectivityConfigurations]`

This module deploys a Network Manager Connectivity Configuration.
Connectivity configurations define hub-and-spoke or mesh topologies applied to one or more network groups.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/connectivityConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkManagers/connectivityConfigurations) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appliesToGroups`](#parameter-appliestogroups) | array | Network Groups for the configuration. |
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
| [`deleteExistingPeering`](#parameter-deleteexistingpeering) | string | Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke". |
| [`description`](#parameter-description) | string | A description of the connectivity configuration. |
| [`isGlobal`](#parameter-isglobal) | string | Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions. |

### Parameter: `appliesToGroups`

Network Groups for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `connectivityTopology`

Connectivity topology type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'HubAndSpoke'
    'Mesh'
  ]
  ```

### Parameter: `name`

The name of the connectivity configuration.

- Required: Yes
- Type: string

### Parameter: `hubs`

List of hub items. This will create peerings between the specified hub and the virtual networks in the network group specified. Required if connectivityTopology is of type "HubAndSpoke".

- Required: No
- Type: array
- Default: `[]`

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `deleteExistingPeering`

Flag if need to remove current existing peerings. If set to "True", all peerings on virtual networks in selected network groups will be removed and replaced with the peerings defined by this configuration. Optional when connectivityTopology is of type "HubAndSpoke".

- Required: No
- Type: string
- Default: `'False'`
- Allowed:
  ```Bicep
  [
    'False'
    'True'
  ]
  ```

### Parameter: `description`

A description of the connectivity configuration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `isGlobal`

Flag if global mesh is supported. By default, mesh connectivity is applied to virtual networks within the same region. If set to "True", a global mesh enables connectivity across regions.

- Required: No
- Type: string
- Default: `'False'`
- Allowed:
  ```Bicep
  [
    'False'
    'True'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed connectivity configuration. |
| `resourceGroupName` | string | The resource group the connectivity configuration was deployed into. |
| `resourceId` | string | The resource ID of the deployed connectivity configuration. |

## Cross-referenced modules

_None_

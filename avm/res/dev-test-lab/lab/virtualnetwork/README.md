# DevTest Lab Virtual Networks `[Microsoft.DevTestLab/labs/virtualnetworks]`

This module deploys a DevTest Lab Virtual Network.

Lab virtual machines must be deployed into a virtual network. This resource type allows configuring the virtual network and subnet settings used for the lab virtual machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/virtualnetworks` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/virtualnetworks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalProviderResourceId`](#parameter-externalproviderresourceid) | string | The resource ID of the virtual network. |
| [`name`](#parameter-name) | string | The name of the virtual network. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedSubnets`](#parameter-allowedsubnets) | array | The allowed subnets of the virtual network. |
| [`description`](#parameter-description) | string | The description of the virtual network. |
| [`subnetOverrides`](#parameter-subnetoverrides) | array | The subnet overrides of the virtual network. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `externalProviderResourceId`

The resource ID of the virtual network.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the virtual network.

- Required: Yes
- Type: string

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allowedSubnets`

The allowed subnets of the virtual network.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `description`

The description of the virtual network.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subnetOverrides`

The subnet overrides of the virtual network.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lab virtual network. |
| `resourceGroupName` | string | The name of the resource group the lab virtual network was created in. |
| `resourceId` | string | The resource ID of the lab virtual network. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

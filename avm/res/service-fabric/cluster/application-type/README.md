# Service Fabric Cluster Application Types `[Microsoft.ServiceFabric/clusters/applicationTypes]`

This module deploys a Service Fabric Cluster Application Type.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceFabric/clusters/applicationTypes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applicationTypes) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceFabricClusterName`](#parameter-servicefabricclustername) | string | The name of the parent Service Fabric cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Application type name. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `serviceFabricClusterName`

The name of the parent Service Fabric cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Application type name.

- Required: No
- Type: string
- Default: `'defaultApplicationType'`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The resource name of the Application type. |
| `resourceGroupName` | string | The resource group of the Application type. |
| `resourceID` | string | The resource ID of the Application type. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

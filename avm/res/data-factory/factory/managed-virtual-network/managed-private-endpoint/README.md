# Data Factory Managed Virtual Network Managed PrivateEndpoints `[Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints]`

This module deploys a Data Factory Managed Virtual Network Managed Private Endpoint.

You can reference the module as follows:
```bicep
module factory 'br/public:avm/res/data-factory/factory/managed-virtual-network/managed-private-endpoint:<version>' = {
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
| `Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_managedvirtualnetworks_managedprivateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks/managedPrivateEndpoints)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdns`](#parameter-fqdns) | array | Fully qualified domain names. |
| [`groupId`](#parameter-groupid) | string | The groupId to which the managed private endpoint is created. |
| [`managedVirtualNetworkName`](#parameter-managedvirtualnetworkname) | string | The name of the parent managed virtual network. |
| [`name`](#parameter-name) | string | The managed private endpoint resource name. |
| [`privateLinkResourceId`](#parameter-privatelinkresourceid) | string | The ARM resource ID of the resource to which the managed private endpoint is created. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFactoryName`](#parameter-datafactoryname) | string | The name of the parent data factory. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `fqdns`

Fully qualified domain names.

- Required: Yes
- Type: array

### Parameter: `groupId`

The groupId to which the managed private endpoint is created.

- Required: Yes
- Type: string

### Parameter: `managedVirtualNetworkName`

The name of the parent managed virtual network.

- Required: Yes
- Type: string

### Parameter: `name`

The managed private endpoint resource name.

- Required: Yes
- Type: string

### Parameter: `privateLinkResourceId`

The ARM resource ID of the resource to which the managed private endpoint is created.

- Required: Yes
- Type: string

### Parameter: `dataFactoryName`

The name of the parent data factory. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed private endpoint. |
| `resourceGroupName` | string | The resource group of the deployed managed private endpoint. |
| `resourceId` | string | The resource ID of the deployed managed private endpoint. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

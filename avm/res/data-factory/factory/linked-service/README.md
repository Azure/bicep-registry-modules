# Data Factory Linked Service `[Microsoft.DataFactory/factories/linkedservices]`

This module deploys a Data Factory Linked Service.

You can reference the module as follows:
```bicep
module factory 'br/public:avm/res/data-factory/factory/linked-service:<version>' = {
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
| `Microsoft.DataFactory/factories/linkedservices` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/linkedservices)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Linked Service. |
| [`type`](#parameter-type) | string | The type of Linked Service. See [ref](https://learn.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/linkedservices?pivots=deployment-language-bicep#linkedservice-objects) for more information. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFactoryName`](#parameter-datafactoryname) | string | The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the Integration Runtime. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`integrationRuntimeName`](#parameter-integrationruntimename) | string | The name of the Integration Runtime to use. |
| [`parameters`](#parameter-parameters) | object | Use this to add parameters for a linked service connection string. |
| [`typeProperties`](#parameter-typeproperties) | object | Used to add connection properties for your linked services. |

### Parameter: `name`

The name of the Linked Service.

- Required: Yes
- Type: string

### Parameter: `type`

The type of Linked Service. See [ref](https://learn.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/linkedservices?pivots=deployment-language-bicep#linkedservice-objects) for more information.

- Required: Yes
- Type: string

### Parameter: `dataFactoryName`

The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of the Integration Runtime.

- Required: No
- Type: string
- Default: `'Linked Service created by avm-res-datafactory-factories'`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `integrationRuntimeName`

The name of the Integration Runtime to use.

- Required: No
- Type: string
- Default: `'none'`

### Parameter: `parameters`

Use this to add parameters for a linked service connection string.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `typeProperties`

Used to add connection properties for your linked services.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Linked Service. |
| `resourceGroupName` | string | The name of the Resource Group the Linked Service was created in. |
| `resourceId` | string | The resource ID of the Linked Service. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

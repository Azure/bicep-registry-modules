# Data Factory Integration RunTimes `[Microsoft.DataFactory/factories/integrationRuntimes]`

This module deploys a Data Factory Managed or Self-Hosted Integration Runtime.

You can reference the module as follows:
```bicep
module factory 'br/public:avm/res/data-factory/factory/integration-runtime:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_integrationruntimes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Integration Runtime. |
| [`type`](#parameter-type) | string | The type of Integration Runtime. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFactoryName`](#parameter-datafactoryname) | string | The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`integrationRuntimeCustomDescription`](#parameter-integrationruntimecustomdescription) | string | The description of the Integration Runtime. |
| [`managedVirtualNetworkName`](#parameter-managedvirtualnetworkname) | string | The name of the Managed Virtual Network if using type "Managed" . |
| [`typeProperties`](#parameter-typeproperties) | object | Integration Runtime type properties. Required if type is "Managed". |

### Parameter: `name`

The name of the Integration Runtime.

- Required: Yes
- Type: string

### Parameter: `type`

The type of Integration Runtime.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Managed'
    'SelfHosted'
  ]
  ```

### Parameter: `dataFactoryName`

The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `integrationRuntimeCustomDescription`

The description of the Integration Runtime.

- Required: No
- Type: string
- Default: `'Managed Integration Runtime created by avm-res-datafactory-factories'`

### Parameter: `managedVirtualNetworkName`

The name of the Managed Virtual Network if using type "Managed" .

- Required: No
- Type: string
- Default: `''`

### Parameter: `typeProperties`

Integration Runtime type properties. Required if type is "Managed".

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Integration Runtime. |
| `resourceGroupName` | string | The name of the Resource Group the Integration Runtime was created in. |
| `resourceId` | string | The resource ID of the Integration Runtime. |

## Notes

### Parameter Usage: `typeProperties`

<details>

<summary>Parameter JSON format</summary>

```json
"typeProperties": {
    "value": {
        "computeProperties": {
            "location": "AutoResolve"
        }
    }
}
```

<details>

<summary>Bicep format</summary>

```bicep
typeProperties: {
    computeProperties: {
        location: 'AutoResolve'
    }
}
```

<details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

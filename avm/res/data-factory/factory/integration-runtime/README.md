# Data Factory Integration RunTimes `[Microsoft.DataFactory/factories/integrationRuntimes]`

This module deploys a Data Factory Managed or Self-Hosted Integration Runtime.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/integrationRuntimes` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes) |

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

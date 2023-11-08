# Operations Management Solutions `[Microsoft.OperationsManagement/solutions]`

This module deploys an Operations Management Solution.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/operations-management.solution:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Ms](#example-2-ms)
- [Nonms](#example-3-nonms)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br:bicep/modules/operations-management.solution:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-omsmin'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'Updates'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "logAnalyticsWorkspaceName": {
      "value": "<logAnalyticsWorkspaceName>"
    },
    "name": {
      "value": "Updates"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Ms_

<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br:bicep/modules/operations-management.solution:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-omsms'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'AzureAutomation'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    product: 'OMSGallery'
    publisher: 'Microsoft'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "logAnalyticsWorkspaceName": {
      "value": "<logAnalyticsWorkspaceName>"
    },
    "name": {
      "value": "AzureAutomation"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "product": {
      "value": "OMSGallery"
    },
    "publisher": {
      "value": "Microsoft"
    }
  }
}
```

</details>
<p>

### Example 3: _Nonms_

<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br:bicep/modules/operations-management.solution:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-omsnonms'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'omsnonms001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    product: 'nonmsTestSolutionProduct'
    publisher: 'nonmsTestSolutionPublisher'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "logAnalyticsWorkspaceName": {
      "value": "<logAnalyticsWorkspaceName>"
    },
    "name": {
      "value": "omsnonms001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "product": {
      "value": "nonmsTestSolutionProduct"
    },
    "publisher": {
      "value": "nonmsTestSolutionPublisher"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | Name of the Log Analytics workspace where the solution will be deployed/enabled. |
| [`name`](#parameter-name) | string | Name of the solution. For Microsoft published gallery solution the target solution resource name will be composed as `{name}({logAnalyticsWorkspaceName})`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`product`](#parameter-product) | string | The product of the deployed solution. For Microsoft published gallery solution it should be `OMSGallery` and the target solution resource product will be composed as `OMSGallery/{name}`. For third party solution, it can be anything. This is case sensitive. |
| [`publisher`](#parameter-publisher) | string | The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsWorkspaceName`

Name of the Log Analytics workspace where the solution will be deployed/enabled.
- Required: Yes
- Type: string

### Parameter: `name`

Name of the solution. For Microsoft published gallery solution the target solution resource name will be composed as `{name}({logAnalyticsWorkspaceName})`.
- Required: Yes
- Type: string

### Parameter: `product`

The product of the deployed solution. For Microsoft published gallery solution it should be `OMSGallery` and the target solution resource product will be composed as `OMSGallery/{name}`. For third party solution, it can be anything. This is case sensitive.
- Required: No
- Type: string
- Default: `'OMSGallery'`

### Parameter: `publisher`

The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`.
- Required: No
- Type: string
- Default: `'Microsoft'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed solution. |
| `resourceGroupName` | string | The resource group where the solution is deployed. |
| `resourceId` | string | The resource ID of the deployed solution. |

## Cross-referenced modules

_None_

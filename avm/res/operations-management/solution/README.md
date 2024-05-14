# Operations Management Solutions `[Microsoft.OperationsManagement/solutions]`

This module deploys an Operations Management Solution.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/operations-management/solution:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Microsoft solution](#example-2-microsoft-solution)
- [Non-Microsoft solution](#example-3-non-microsoft-solution)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br/public:avm/res/operations-management/solution:<version>' = {
  name: 'solutionDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'Updates'
    // Non-required parameters
    location: '<location>'
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
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Microsoft solution_

This instance deploys the module with a Microsoft solution.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br/public:avm/res/operations-management/solution:<version>' = {
  name: 'solutionDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'AzureAutomation'
    // Non-required parameters
    location: '<location>'
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
    "location": {
      "value": "<location>"
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

### Example 3: _Non-Microsoft solution_

This instance deploys the module with a third party (Non-Microsoft) solution.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br/public:avm/res/operations-management/solution:<version>' = {
  name: 'solutionDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'omsnonms001'
    // Non-required parameters
    location: '<location>'
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
    "location": {
      "value": "<location>"
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br/public:avm/res/operations-management/solution:<version>' = {
  name: 'solutionDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: 'AzureAutomation'
    // Non-required parameters
    location: '<location>'
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
    "location": {
      "value": "<location>"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | Name of the Log Analytics workspace where the solution will be deployed/enabled. |
| [`name`](#parameter-name) | string | Name of the solution. For Microsoft published gallery solution the target solution resource name will be composed as `{name}({logAnalyticsWorkspaceName})`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`product`](#parameter-product) | string | The product of the deployed solution. For Microsoft published gallery solution it should be `OMSGallery` and the target solution resource product will be composed as `OMSGallery/{name}`. For third party solution, it can be anything. This is case sensitive. |
| [`publisher`](#parameter-publisher) | string | The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`. |

### Parameter: `logAnalyticsWorkspaceName`

Name of the Log Analytics workspace where the solution will be deployed/enabled.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the solution. For Microsoft published gallery solution the target solution resource name will be composed as `{name}({logAnalyticsWorkspaceName})`.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

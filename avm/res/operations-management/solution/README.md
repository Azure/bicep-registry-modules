# Operations Management Solutions `[Microsoft.OperationsManagement/solutions]`

This module deploys an Operations Management Solution.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
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
- [SQLAuditing solution](#example-4-sqlauditing-solution)
- [WAF-aligned](#example-5-waf-aligned)

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
    name: '<name>'
    plan: {
      product: 'OMSGallery/Updates'
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
      "value": "<name>"
    },
    "plan": {
      "value": {
        "product": "OMSGallery/Updates"
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/operations-management/solution:<version>'

// Required parameters
param logAnalyticsWorkspaceName = '<logAnalyticsWorkspaceName>'
param name = '<name>'
param plan = {
  product: 'OMSGallery/Updates'
}
// Non-required parameters
param location = '<location>'
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
    name: '<name>'
    plan: {
      product: 'OMSGallery/AzureAutomation'
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
      "value": "<name>"
    },
    "plan": {
      "value": {
        "product": "OMSGallery/AzureAutomation"
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/operations-management/solution:<version>'

// Required parameters
param logAnalyticsWorkspaceName = '<logAnalyticsWorkspaceName>'
param name = '<name>'
param plan = {
  product: 'OMSGallery/AzureAutomation'
}
// Non-required parameters
param location = '<location>'
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
    plan: {
      name: 'nonmsTestSolutionPlan'
      product: 'nonmsTestSolutionProduct'
      publisher: 'nonmsTestSolutionPublisher'
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
    "plan": {
      "value": {
        "name": "nonmsTestSolutionPlan",
        "product": "nonmsTestSolutionProduct",
        "publisher": "nonmsTestSolutionPublisher"
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/operations-management/solution:<version>'

// Required parameters
param logAnalyticsWorkspaceName = '<logAnalyticsWorkspaceName>'
param name = 'omsnonms001'
param plan = {
  name: 'nonmsTestSolutionPlan'
  product: 'nonmsTestSolutionProduct'
  publisher: 'nonmsTestSolutionPublisher'
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 4: _SQLAuditing solution_

This instance deploys the module with the SQLAuditing solution. This solution is authored by Microsoft, but uses a non-standard value for the `product` parameter.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br/public:avm/res/operations-management/solution:<version>' = {
  name: 'solutionDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: '<name>'
    plan: {
      product: 'SQLAuditing'
      publisher: 'Microsoft'
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
      "value": "<name>"
    },
    "plan": {
      "value": {
        "product": "SQLAuditing",
        "publisher": "Microsoft"
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/operations-management/solution:<version>'

// Required parameters
param logAnalyticsWorkspaceName = '<logAnalyticsWorkspaceName>'
param name = '<name>'
param plan = {
  product: 'SQLAuditing'
  publisher: 'Microsoft'
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module solution 'br/public:avm/res/operations-management/solution:<version>' = {
  name: 'solutionDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceName: '<logAnalyticsWorkspaceName>'
    name: '<name>'
    plan: {
      name: '<name>'
      product: 'OMSGallery/AzureAutomation'
      publisher: 'Microsoft'
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
      "value": "<name>"
    },
    "plan": {
      "value": {
        "name": "<name>",
        "product": "OMSGallery/AzureAutomation",
        "publisher": "Microsoft"
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/operations-management/solution:<version>'

// Required parameters
param logAnalyticsWorkspaceName = '<logAnalyticsWorkspaceName>'
param name = '<name>'
param plan = {
  name: '<name>'
  product: 'OMSGallery/AzureAutomation'
  publisher: 'Microsoft'
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | Name of the Log Analytics workspace where the solution will be deployed/enabled. |
| [`name`](#parameter-name) | string | Name of the solution.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, the name should be in the pattern: `SolutionType[WorkspaceName]`, for example `MySolution[contoso-Logs]`.<p>The solution type is case-sensitive. |
| [`plan`](#parameter-plan) | object | Plan for solution object supported by the OperationsManagement resource provider. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `logAnalyticsWorkspaceName`

Name of the Log Analytics workspace where the solution will be deployed/enabled.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the solution.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, the name should be in the pattern: `SolutionType[WorkspaceName]`, for example `MySolution[contoso-Logs]`.<p>The solution type is case-sensitive.

- Required: Yes
- Type: string

### Parameter: `plan`

Plan for solution object supported by the OperationsManagement resource provider.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`product`](#parameter-planproduct) | string | The product name of the deployed solution.<p>For Microsoft published gallery solution it should be `OMSGallery/{solutionType}`, for example `OMSGallery/AntiMalware`.<p>For a third party solution, it can be anything.<p>This is case sensitive. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-planname) | string | Name of the solution to be created.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, it can be anything.<p>The solution type is case-sensitive.<p>If not provided, the value of the `name` parameter will be used. |
| [`publisher`](#parameter-planpublisher) | string | The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`, which is the default value. |

### Parameter: `plan.product`

The product name of the deployed solution.<p>For Microsoft published gallery solution it should be `OMSGallery/{solutionType}`, for example `OMSGallery/AntiMalware`.<p>For a third party solution, it can be anything.<p>This is case sensitive.

- Required: Yes
- Type: string

### Parameter: `plan.name`

Name of the solution to be created.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, it can be anything.<p>The solution type is case-sensitive.<p>If not provided, the value of the `name` parameter will be used.

- Required: No
- Type: string

### Parameter: `plan.publisher`

The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`, which is the default value.

- Required: No
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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed solution. |
| `resourceGroupName` | string | The resource group where the solution is deployed. |
| `resourceId` | string | The resource ID of the deployed solution. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

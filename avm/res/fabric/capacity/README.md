# Fabric Capacities `[Microsoft.Fabric/capacities]`

This module deploys Fabric capacities, which provide the compute resources for all the experiences in Fabric.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Fabric/capacities` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/fabric/capacity:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module capacity 'br/public:avm/res/fabric/capacity:<version>' = {
  name: 'capacityDeployment'
  params: {
    // Required parameters
    adminMembers: [
      '<adminMembersSecret>'
    ]
    name: 'fcmin001'
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
    "adminMembers": {
      "value": [
        "<adminMembersSecret>"
      ]
    },
    "name": {
      "value": "fcmin001"
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
using 'br/public:avm/res/fabric/capacity:<version>'

// Required parameters
param adminMembers = [
  '<adminMembersSecret>'
]
param name = 'fcmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module capacity 'br/public:avm/res/fabric/capacity:<version>' = {
  name: 'capacityDeployment'
  params: {
    // Required parameters
    adminMembers: [
      '<adminMembersSecret>'
    ]
    name: 'fcwaf001'
    // Non-required parameters
    location: '<location>'
    skuName: 'F64'
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
    "adminMembers": {
      "value": [
        "<adminMembersSecret>"
      ]
    },
    "name": {
      "value": "fcwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "F64"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/fabric/capacity:<version>'

// Required parameters
param adminMembers = [
  '<adminMembersSecret>'
]
param name = 'fcwaf001'
// Non-required parameters
param location = '<location>'
param skuName = 'F64'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminMembers`](#parameter-adminmembers) | array | List of admin members. Format: ["something@domain.com"]. |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`skuName`](#parameter-skuname) | string | SKU tier of the Fabric resource. |
| [`skuTier`](#parameter-skutier) | string | SKU name of the Fabric resource. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `adminMembers`

List of admin members. Format: ["something@domain.com"].

- Required: Yes
- Type: array

### Parameter: `name`

Name of the resource to create.

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

### Parameter: `skuName`

SKU tier of the Fabric resource.

- Required: No
- Type: string
- Default: `'F2'`
- Allowed:
  ```Bicep
  [
    'F1024'
    'F128'
    'F16'
    'F2'
    'F2048'
    'F256'
    'F32'
    'F4'
    'F512'
    'F64'
    'F8'
  ]
  ```

### Parameter: `skuTier`

SKU name of the Fabric resource.

- Required: No
- Type: string
- Default: `'Fabric'`
- Allowed:
  ```Bicep
  [
    'Fabric'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Fabric resource. |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |
| `resourceId` | string | The resource ID of the deployed Fabric resource. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

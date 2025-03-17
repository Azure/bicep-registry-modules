# Maintenance Configuration Assignments `[Microsoft.Maintenance/configurationAssignments]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
> 
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys a Maintenance Configuration Assignment.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/maintenance/configuration-assignment:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters. This instance uses filters to define a dynamic scope and assign it to the input maintenance configuration. The dynamic scope will be resolved at run time. 


<details>

<summary>via Bicep module</summary>

```bicep
module configurationAssignment 'br/public:avm/res/maintenance/configuration-assignment:<version>' = {
  name: 'configurationAssignmentDeployment'
  params: {
    // Required parameters
    maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
    name: 'mcamin001'
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
    "maintenanceConfigurationResourceId": {
      "value": "<maintenanceConfigurationResourceId>"
    },
    "name": {
      "value": "mcamin001"
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
using 'br/public:avm/res/maintenance/configuration-assignment:<version>'

// Required parameters
param maintenanceConfigurationResourceId = '<maintenanceConfigurationResourceId>'
param name = 'mcamin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework. This instance assigns an existing Linux virtual machine to the input maintenance configuration.


<details>

<summary>via Bicep module</summary>

```bicep
module configurationAssignment 'br/public:avm/res/maintenance/configuration-assignment:<version>' = {
  name: 'configurationAssignmentDeployment'
  params: {
    // Required parameters
    maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
    name: 'mcawaf001'
    // Non-required parameters
    location: '<location>'
    resourceId: '<resourceId>'
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
    "maintenanceConfigurationResourceId": {
      "value": "<maintenanceConfigurationResourceId>"
    },
    "name": {
      "value": "mcawaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "resourceId": {
      "value": "<resourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/maintenance/configuration-assignment:<version>'

// Required parameters
param maintenanceConfigurationResourceId = '<maintenanceConfigurationResourceId>'
param name = 'mcawaf001'
// Non-required parameters
param location = '<location>'
param resourceId = '<resourceId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maintenanceConfigurationResourceId`](#parameter-maintenanceconfigurationresourceid) | string | The maintenance configuration resource ID. |
| [`name`](#parameter-name) | string | Maintenance configuration assignment Name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`filter`](#parameter-filter) | object | The unique resource ID to assign the configuration to. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`resourceId`](#parameter-resourceid) | string | The unique resource ID to assign the configuration to. |

### Parameter: `maintenanceConfigurationResourceId`

The maintenance configuration resource ID.

- Required: Yes
- Type: string

### Parameter: `name`

Maintenance configuration assignment Name.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `filter`

The unique resource ID to assign the configuration to.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`locations`](#parameter-filterlocations) | array | List of locations to scope the query to. |
| [`osTypes`](#parameter-filterostypes) | array | List of allowed operating systems. |
| [`resourceGroups`](#parameter-filterresourcegroups) | array | List of allowed resource group names. |
| [`resourceTypes`](#parameter-filterresourcetypes) | array | List of allowed resource types. |
| [`tagSettings`](#parameter-filtertagsettings) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `filter.locations`

List of locations to scope the query to.

- Required: No
- Type: array

### Parameter: `filter.osTypes`

List of allowed operating systems.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `filter.resourceGroups`

List of allowed resource group names.

- Required: No
- Type: array

### Parameter: `filter.resourceTypes`

List of allowed resource types.

- Required: No
- Type: array

### Parameter: `filter.tagSettings`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `resourceId`

The unique resource ID to assign the configuration to.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Maintenance configuration assignment. |
| `resourceGroupName` | string | The name of the resource group the Maintenance configuration assignment was created in. |
| `resourceId` | string | The resource ID of the Maintenance configuration assignment. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

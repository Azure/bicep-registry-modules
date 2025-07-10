# Maintenance Configuration Assignments `[Microsoft.Maintenance/configurationAssignments]`

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
- [Using filter tags](#example-2-using-filter-tags)
- [WAF-aligned](#example-3-waf-aligned)
- [Multi resource group](#example-4-multi-resource-group)

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
    filter: {
      osTypes: [
        'Linux'
        'Windows'
      ]
      resourceTypes: [
        'Virtual Machines'
      ]
    }
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
    "filter": {
      "value": {
        "osTypes": [
          "Linux",
          "Windows"
        ],
        "resourceTypes": [
          "Virtual Machines"
        ]
      }
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
param filter = {
  osTypes: [
    'Linux'
    'Windows'
  ]
  resourceTypes: [
    'Virtual Machines'
  ]
}
```

</details>
<p>

### Example 2: _Using filter tags_

This instance deploys the module using filters with tags to define a dynamic scope and assign it to the input maintenance configuration. The dynamic scope will be resolved at run time.


<details>

<summary>via Bicep module</summary>

```bicep
module configurationAssignment 'br/public:avm/res/maintenance/configuration-assignment:<version>' = {
  name: 'configurationAssignmentDeployment'
  params: {
    // Required parameters
    maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
    name: 'mcatag001'
    // Non-required parameters
    filter: {
      osTypes: [
        'Linux'
        'Windows'
      ]
      resourceTypes: [
        'Virtual Machines'
      ]
      tagSettings: {
        filterOperator: 'All'
        tags: {
          cake: [
            'lie'
          ]
          foo: [
            'bar'
          ]
        }
      }
    }
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
      "value": "mcatag001"
    },
    // Non-required parameters
    "filter": {
      "value": {
        "osTypes": [
          "Linux",
          "Windows"
        ],
        "resourceTypes": [
          "Virtual Machines"
        ],
        "tagSettings": {
          "filterOperator": "All",
          "tags": {
            "cake": [
              "lie"
            ],
            "foo": [
              "bar"
            ]
          }
        }
      }
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
param name = 'mcatag001'
// Non-required parameters
param filter = {
  osTypes: [
    'Linux'
    'Windows'
  ]
  resourceTypes: [
    'Virtual Machines'
  ]
  tagSettings: {
    filterOperator: 'All'
    tags: {
      cake: [
        'lie'
      ]
      foo: [
        'bar'
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

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
param resourceId = '<resourceId>'
```

</details>
<p>

### Example 4: _Multi resource group_

This instance deploys the module leveraging virtual machine and maintenance configuration dependencies from two different resource groups. This instance assigns an existing Windows virtual machine to the input maintenance configuration.


<details>

<summary>via Bicep module</summary>

```bicep
module configurationAssignment 'br/public:avm/res/maintenance/configuration-assignment:<version>' = {
  name: 'configurationAssignmentDeployment'
  params: {
    // Required parameters
    maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
    name: 'mcamrg001'
    // Non-required parameters
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
      "value": "mcamrg001"
    },
    // Non-required parameters
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
param name = 'mcamrg001'
// Non-required parameters
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

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filter`](#parameter-filter) | object | Properties of the dynamic configuration assignment. Required if resourceId is not provided. |
| [`resourceId`](#parameter-resourceid) | string | The unique virtual machine resource ID to assign the configuration to. Required if filter is not provided. If resourceId is provided, filter is ignored. If provided, the module scope must be set to the resource group of the virtual machine. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `maintenanceConfigurationResourceId`

The maintenance configuration resource ID.

- Required: Yes
- Type: string

### Parameter: `name`

Maintenance configuration assignment Name.

- Required: Yes
- Type: string

### Parameter: `filter`

Properties of the dynamic configuration assignment. Required if resourceId is not provided.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`locations`](#parameter-filterlocations) | array | List of locations to scope the query to. |
| [`osTypes`](#parameter-filterostypes) | array | List of allowed operating systems. |
| [`resourceGroups`](#parameter-filterresourcegroups) | array | List of allowed resource group names. |
| [`resourceTypes`](#parameter-filterresourcetypes) | array | List of allowed resource types. |
| [`tagSettings`](#parameter-filtertagsettings) | object | Tag settings for the VM. |

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

Tag settings for the VM.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filterOperator`](#parameter-filtertagsettingsfilteroperator) | string | Filter VMs by Any or All specified tags. |
| [`tags`](#parameter-filtertagsettingstags) | object | Dictionary of tags with its list of values. |

### Parameter: `filter.tagSettings.filterOperator`

Filter VMs by Any or All specified tags.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'All'
    'Any'
  ]
  ```

### Parameter: `filter.tagSettings.tags`

Dictionary of tags with its list of values.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-filtertagsettingstags>any_other_property<) | array | A key-value pair. Note that although the value is an array, it must be a single value for each tag. |

### Parameter: `filter.tagSettings.tags.>Any_other_property<`

A key-value pair. Note that although the value is an array, it must be a single value for each tag.

- Required: Yes
- Type: array

### Parameter: `resourceId`

The unique virtual machine resource ID to assign the configuration to. Required if filter is not provided. If resourceId is provided, filter is ignored. If provided, the module scope must be set to the resource group of the virtual machine.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Maintenance configuration assignment. |
| `resourceGroupName` | string | The name of the resource group the Maintenance configuration assignment was created in. |
| `resourceId` | string | The resource ID of the Maintenance configuration assignment. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

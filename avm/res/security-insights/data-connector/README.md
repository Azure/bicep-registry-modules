# Security Insights Data Connectors `[Microsoft.SecurityInsights/dataConnectors]`

This module deploys a Security Insights Data Connector.

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
| `Microsoft.SecurityInsights/dataConnectors` | [2024-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-10-01-preview/dataConnectors) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/security-insights/data-connector:<version>`.

- [Using defaults](#example-1-using-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using defaults_

This instance deploys the module with minimal required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module dataConnector 'br/public:avm/res/security-insights/data-connector:<version>' = {
  name: 'dataConnectorDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    connectors: [
      {
        name: 'MicrosoftThreatIntelligence'
        properties: {
          dataTypes: {
            microsoftEmergingThreatFeed: {
              lookbackPeriod: '2025-01-01T00:00:00Z'
              state: 'Enabled'
            }
          }
          tenantId: '<tenantId>'
        }
      }
    ]
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
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "connectors": {
      "value": [
        {
          "name": "MicrosoftThreatIntelligence",
          "properties": {
            "dataTypes": {
              "microsoftEmergingThreatFeed": {
                "lookbackPeriod": "2025-01-01T00:00:00Z",
                "state": "Enabled"
              }
            },
            "tenantId": "<tenantId>"
          }
        }
      ]
    },
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
using 'br/public:avm/res/security-insights/data-connector:<version>'

// Required parameters
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param connectors = [
  {
    name: 'MicrosoftThreatIntelligence'
    properties: {
      dataTypes: {
        microsoftEmergingThreatFeed: {
          lookbackPeriod: '2025-01-01T00:00:00Z'
          state: 'Enabled'
        }
      }
      tenantId: '<tenantId>'
    }
  }
]
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module with WAF-aligned requirements.


<details>

<summary>via Bicep module</summary>

```bicep
module dataConnector 'br/public:avm/res/security-insights/data-connector:<version>' = {
  name: 'dataConnectorDeployment'
  params: {
    // Required parameters
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    connectors: [
      {
        name: 'MicrosoftThreatIntelligence'
        properties: {
          dataTypes: {
            microsoftEmergingThreatFeed: {
              lookbackPeriod: '2025-01-01T00:00:00Z'
              state: 'Enabled'
            }
          }
          tenantId: '<tenantId>'
        }
      }
    ]
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
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "connectors": {
      "value": [
        {
          "name": "MicrosoftThreatIntelligence",
          "properties": {
            "dataTypes": {
              "microsoftEmergingThreatFeed": {
                "lookbackPeriod": "2025-01-01T00:00:00Z",
                "state": "Enabled"
              }
            },
            "tenantId": "<tenantId>"
          }
        }
      ]
    },
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
using 'br/public:avm/res/security-insights/data-connector:<version>'

// Required parameters
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param connectors = [
  {
    name: 'MicrosoftThreatIntelligence'
    properties: {
      dataTypes: {
        microsoftEmergingThreatFeed: {
          lookbackPeriod: '2025-01-01T00:00:00Z'
          state: 'Enabled'
        }
      }
      tenantId: '<tenantId>'
    }
  }
]
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectors`](#parameter-connectors) | array | The type of Data Connector. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `connectors`

The type of Data Connector.

- Required: No
- Type: array
- Discriminator: `name`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`MicrosoftThreatIntelligence`](#variant-connectorsname-microsoftthreatintelligence) | The type of MicrosoftThreatIntelligenceType configuration. |
| [`ThreatIntelligence`](#variant-connectorsname-threatintelligence) | The type of ThreatIntelligenceType configuration. |

### Variant: `connectors.name-MicrosoftThreatIntelligence`
The type of MicrosoftThreatIntelligenceType configuration.

To use this variant, set the property `name` to `MicrosoftThreatIntelligence`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-microsoftthreatintelligencename) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-microsoftthreatintelligenceproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-MicrosoftThreatIntelligence.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftThreatIntelligence'
  ]
  ```

### Parameter: `connectors.name-MicrosoftThreatIntelligence.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-microsoftthreatintelligencepropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-connectorsname-microsoftthreatintelligencepropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `connectors.name-MicrosoftThreatIntelligence.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`microsoftEmergingThreatFeed`](#parameter-connectorsname-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeed) | object | Data type for Microsoft Threat Intelligence Platforms data connector. |

### Parameter: `connectors.name-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed`

Data type for Microsoft Threat Intelligence Platforms data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-connectorsname-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeedlookbackperiod) | string | The lookback period for the feed to be imported. |
| [`state`](#parameter-connectorsname-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeedstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `connectors.name-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed.lookbackPeriod`

The lookback period for the feed to be imported.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftThreatIntelligence.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `connectors.name-ThreatIntelligence`
The type of ThreatIntelligenceType configuration.

To use this variant, set the property `name` to `ThreatIntelligence`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-threatintelligencename) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-threatintelligenceproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-ThreatIntelligence.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ThreatIntelligence'
  ]
  ```

### Parameter: `connectors.name-ThreatIntelligence.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-threatintelligencepropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-connectorsname-threatintelligencepropertiestenantid) | string | The tenant id to connect to, and get the data from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tipLookbackPeriod`](#parameter-connectorsname-threatintelligencepropertiestiplookbackperiod) | string | The lookback period for the feed to be imported. |

### Parameter: `connectors.name-ThreatIntelligence.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indicators`](#parameter-connectorsname-threatintelligencepropertiesdatatypesindicators) | object | Data type for indicators connection. |

### Parameter: `connectors.name-ThreatIntelligence.properties.dataTypes.indicators`

Data type for indicators connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-threatintelligencepropertiesdatatypesindicatorsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `connectors.name-ThreatIntelligence.properties.dataTypes.indicators.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-ThreatIntelligence.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Parameter: `connectors.name-ThreatIntelligence.properties.tipLookbackPeriod`

The lookback period for the feed to be imported.

- Required: No
- Type: string

### Parameter: `workspaceResourceId`

The resource ID of the Log Analytics workspace.

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Security Insights Data Connector. |
| `resourceGroupName` | string | The resource group where the Security Insights Data Connector is deployed. |
| `resourceId` | string | The resource ID of the Security Insights Data Connector. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

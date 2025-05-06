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

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/security-insights/data-connectors:<version>`.

- [Using defaults](#example-1-using-defaults)

### Example 1: _Using defaults_

This instance deploys the module with minimal required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module dataConnectors 'br/public:avm/res/security-insights/data-connectors:<version>' = {
  name: 'dataConnectorsDeployment'
  params: {
    // Required parameters
    kind: 'MicrosoftThreatIntelligence'
    name: '<name>'
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    location: '<location>'
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
    "kind": {
      "value": "MicrosoftThreatIntelligence"
    },
    "name": {
      "value": "<name>"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "properties": {
      "value": {
        "dataTypes": {
          "microsoftEmergingThreatFeed": {
            "lookbackPeriod": "2025-01-01T00:00:00Z",
            "state": "Enabled"
          }
        },
        "tenantId": "<tenantId>"
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
using 'br/public:avm/res/security-insights/data-connectors:<version>'

// Required parameters
param kind = 'MicrosoftThreatIntelligence'
param name = '<name>'
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param location = '<location>'
param properties = {
  dataTypes: {
    microsoftEmergingThreatFeed: {
      lookbackPeriod: '2025-01-01T00:00:00Z'
      state: 'Enabled'
    }
  }
  tenantId: '<tenantId>'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | The type of the Data Connector. |
| [`name`](#parameter-name) | string | Name of the Security Insights Data Connector. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`properties`](#parameter-properties) | object | Properties for the Data Connector based on kind. |

### Parameter: `kind`

The type of the Data Connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesCloudTrail'
    'AmazonWebServicesS3'
    'APIPolling'
    'AzureActiveDirectory'
    'AzureAdvancedThreatProtection'
    'AzureSecurityCenter'
    'Dynamics365'
    'GCP'
    'GenericUI'
    'IOT'
    'MicrosoftCloudAppSecurity'
    'MicrosoftDefenderAdvancedThreatProtection'
    'MicrosoftPurviewInformationProtection'
    'MicrosoftThreatIntelligence'
    'MicrosoftThreatProtection'
    'Office365'
    'Office365Project'
    'OfficeATP'
    'OfficeIRM'
    'OfficePowerBI'
    'PurviewAudit'
    'RestApiPoller'
    'ThreatIntelligence'
    'ThreatIntelligenceTaxii'
  ]
  ```

### Parameter: `name`

Name of the Security Insights Data Connector.

- Required: Yes
- Type: string

### Parameter: `workspaceResourceId`

The resource ID of the Log Analytics workspace.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `properties`

Properties for the Data Connector based on kind.

- Required: No
- Type: object
- Default: `{}`

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

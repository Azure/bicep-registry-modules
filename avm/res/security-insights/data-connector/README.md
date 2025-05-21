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
- [Using defaults](#example-2-using-defaults)
- [WAF-aligned](#example-3-waf-aligned)

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

### Example 2: _Using defaults_

This instance deploys the module with multiple data connectors.


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
      {
        name: 'IOT'
        properties: {
          dataTypes: {
            alerts: {
              state: 'Enabled'
            }
          }
          subscriptionId: '<subscriptionId>'
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
        },
        {
          "name": "IOT",
          "properties": {
            "dataTypes": {
              "alerts": {
                "state": "Enabled"
              }
            },
            "subscriptionId": "<subscriptionId>"
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
  {
    name: 'IOT'
    properties: {
      dataTypes: {
        alerts: {
          state: 'Enabled'
        }
      }
      subscriptionId: '<subscriptionId>'
    }
  }
]
param location = '<location>'
```

</details>
<p>

### Example 3: _WAF-aligned_

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
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectors`](#parameter-connectors) | array | The type of Data Connector. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `workspaceResourceId`

The resource ID of the Log Analytics workspace.

- Required: Yes
- Type: string

### Parameter: `connectors`

The type of Data Connector.

- Required: No
- Type: array
- Discriminator: `name`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`AmazonWebServicesCloudTrail`](#variant-connectorsname-amazonwebservicescloudtrail) | The type of AmazonWebServicesCloudTrail configuration. |
| [`AmazonWebServicesS3`](#variant-connectorsname-amazonwebservicess3) | The type of AmazonWebServicesS3 configuration. |
| [`APIPolling`](#variant-connectorsname-apipolling) | The type of API Polling configuration. |
| [`AzureActiveDirectory`](#variant-connectorsname-azureactivedirectory) | The type of AzureActiveDirectory configuration. |
| [`AzureAdvancedThreatProtection`](#variant-connectorsname-azureadvancedthreatprotection) | The type of AzureAdvancedThreatProtection configuration. |
| [`AzureSecurityCenter`](#variant-connectorsname-azuresecuritycenter) | The type of AzureSecurityCenter configuration. |
| [`Dynamics365`](#variant-connectorsname-dynamics365) | The type of Dynamics365 configuration. |
| [`GCP`](#variant-connectorsname-gcp) | The type of GCP configuration. |
| [`GenericUI`](#variant-connectorsname-genericui) | The type of Generic UI configuration. |
| [`IOT`](#variant-connectorsname-iot) | The type of IOT configuration. |
| [`MicrosoftCloudAppSecurity`](#variant-connectorsname-microsoftcloudappsecurity) | The type of Microsoft Cloud App Security configuration. |
| [`MicrosoftDefenderAdvancedThreatProtection`](#variant-connectorsname-microsoftdefenderadvancedthreatprotection) | The type of Microsoft Defender Advanced Threat Protection configuration. |
| [`MicrosoftPurviewInformationProtection`](#variant-connectorsname-microsoftpurviewinformationprotection) | The type of Microsoft Purview Information Protection configuration. |
| [`MicrosoftThreatIntelligence`](#variant-connectorsname-microsoftthreatintelligence) | The type of MicrosoftThreatIntelligenceType configuration. |
| [`MicrosoftThreatProtection`](#variant-connectorsname-microsoftthreatprotection) | The type of Microsoft Threat Protection configuration. |
| [`Office365`](#variant-connectorsname-office365) | The type of Office 365 configuration. |
| [`Office365Project`](#variant-connectorsname-office365project) | The type of Office 365 Project configuration. |
| [`OfficeATP`](#variant-connectorsname-officeatp) | The type of Office ATP configuration. |
| [`OfficeIRM`](#variant-connectorsname-officeirm) | The type of Office IRM configuration. |
| [`OfficePowerBI`](#variant-connectorsname-officepowerbi) | The type of Office Power BI configuration. |
| [`PurviewAudit`](#variant-connectorsname-purviewaudit) | The type of Purview Audit configuration. |
| [`RestApiPoller`](#variant-connectorsname-restapipoller) | The type of REST API Poller configuration. |
| [`ThreatIntelligence`](#variant-connectorsname-threatintelligence) | The type of ThreatIntelligenceType configuration. |
| [`ThreatIntelligenceTaxii`](#variant-connectorsname-threatintelligencetaxii) | The type of Threat Intelligence TAXII configuration. |

### Variant: `connectors.name-AmazonWebServicesCloudTrail`
The type of AmazonWebServicesCloudTrail configuration.

To use this variant, set the property `name` to `AmazonWebServicesCloudTrail`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-amazonwebservicescloudtrailname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-amazonwebservicescloudtrailproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-AmazonWebServicesCloudTrail.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesCloudTrail'
  ]
  ```

### Parameter: `connectors.name-AmazonWebServicesCloudTrail.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`awsRoleArn`](#parameter-connectorsname-amazonwebservicescloudtrailpropertiesawsrolearn) | string | The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account. |
| [`dataTypes`](#parameter-connectorsname-amazonwebservicescloudtrailpropertiesdatatypes) | object | The available data types for the connector. |

### Parameter: `connectors.name-AmazonWebServicesCloudTrail.properties.awsRoleArn`

The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AmazonWebServicesCloudTrail.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-amazonwebservicescloudtrailpropertiesdatatypeslogs) | object | Data type for Amazon Web Services Cloud Trail data connector. |

### Parameter: `connectors.name-AmazonWebServicesCloudTrail.properties.dataTypes.logs`

Data type for Amazon Web Services Cloud Trail data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-amazonwebservicescloudtrailpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `connectors.name-AmazonWebServicesCloudTrail.properties.dataTypes.logs.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Variant: `connectors.name-AmazonWebServicesS3`
The type of AmazonWebServicesS3 configuration.

To use this variant, set the property `name` to `AmazonWebServicesS3`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-amazonwebservicess3name) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-amazonwebservicess3properties) | object | The properties of the data connector. |

### Parameter: `connectors.name-AmazonWebServicesS3.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesS3'
  ]
  ```

### Parameter: `connectors.name-AmazonWebServicesS3.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-amazonwebservicess3propertiesdatatypes) | object | The available data types for the connector. |
| [`destinationTable`](#parameter-connectorsname-amazonwebservicess3propertiesdestinationtable) | string | The logs destination table name in LogAnalytics. |
| [`roleArn`](#parameter-connectorsname-amazonwebservicess3propertiesrolearn) | string | The AWS Role Arn that is used to access the Aws account. |
| [`sqsUrls`](#parameter-connectorsname-amazonwebservicess3propertiessqsurls) | array | The AWS sqs urls for the connector. |

### Parameter: `connectors.name-AmazonWebServicesS3.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-amazonwebservicess3propertiesdatatypeslogs) | object | Data type for Amazon Web Services S3 data connector. |

### Parameter: `connectors.name-AmazonWebServicesS3.properties.dataTypes.logs`

Data type for Amazon Web Services S3 data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-amazonwebservicess3propertiesdatatypeslogsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `connectors.name-AmazonWebServicesS3.properties.dataTypes.logs.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AmazonWebServicesS3.properties.destinationTable`

The logs destination table name in LogAnalytics.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AmazonWebServicesS3.properties.roleArn`

The AWS Role Arn that is used to access the Aws account.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AmazonWebServicesS3.properties.sqsUrls`

The AWS sqs urls for the connector.

- Required: Yes
- Type: array

### Variant: `connectors.name-APIPolling`
The type of API Polling configuration.

To use this variant, set the property `name` to `APIPolling`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-apipollingname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-apipollingproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-APIPolling.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'APIPolling'
  ]
  ```

### Parameter: `connectors.name-APIPolling.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parseMappings`](#parameter-connectorsname-apipollingpropertiesparsemappings) | array | The parsing rules for the response. |
| [`pollingConfig`](#parameter-connectorsname-apipollingpropertiespollingconfig) | object | The polling configuration for the data connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-connectorsname-apipollingpropertieslookbackperiod) | string | The lookback period for historical data. |

### Parameter: `connectors.name-APIPolling.properties.parseMappings`

The parsing rules for the response.

- Required: Yes
- Type: array

### Parameter: `connectors.name-APIPolling.properties.pollingConfig`

The polling configuration for the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-connectorsname-apipollingpropertiespollingconfigauth) | object | The authentication configuration. |
| [`request`](#parameter-connectorsname-apipollingpropertiespollingconfigrequest) | object | The request configuration. |

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.auth`

The authentication configuration.

- Required: Yes
- Type: object

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoint`](#parameter-connectorsname-apipollingpropertiespollingconfigrequestendpoint) | string | The API endpoint to poll. |
| [`method`](#parameter-connectorsname-apipollingpropertiespollingconfigrequestmethod) | string | The HTTP method to use. |
| [`rateLimitQps`](#parameter-connectorsname-apipollingpropertiespollingconfigrequestratelimitqps) | int | Rate limit in queries per second. |
| [`timeout`](#parameter-connectorsname-apipollingpropertiespollingconfigrequesttimeout) | string | Request timeout duration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`queryParameters`](#parameter-connectorsname-apipollingpropertiespollingconfigrequestqueryparameters) | object | Query parameters to include in the request. |

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.request.endpoint`

The API endpoint to poll.

- Required: Yes
- Type: string

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.request.method`

The HTTP method to use.

- Required: Yes
- Type: string

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.request.rateLimitQps`

Rate limit in queries per second.

- Required: Yes
- Type: int

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.request.timeout`

Request timeout duration.

- Required: Yes
- Type: string

### Parameter: `connectors.name-APIPolling.properties.pollingConfig.request.queryParameters`

Query parameters to include in the request.

- Required: No
- Type: object

### Parameter: `connectors.name-APIPolling.properties.lookbackPeriod`

The lookback period for historical data.

- Required: No
- Type: string

### Variant: `connectors.name-AzureActiveDirectory`
The type of AzureActiveDirectory configuration.

To use this variant, set the property `name` to `AzureActiveDirectory`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-azureactivedirectoryname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-azureactivedirectoryproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-AzureActiveDirectory.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureActiveDirectory'
  ]
  ```

### Parameter: `connectors.name-AzureActiveDirectory.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-azureactivedirectorypropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-connectorsname-azureactivedirectorypropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `connectors.name-AzureActiveDirectory.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-azureactivedirectorypropertiesdatatypesalerts) | object | Alerts data type connection. |

### Parameter: `connectors.name-AzureActiveDirectory.properties.dataTypes.alerts`

Alerts data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-azureactivedirectorypropertiesdatatypesalertsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `connectors.name-AzureActiveDirectory.properties.dataTypes.alerts.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AzureActiveDirectory.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `connectors.name-AzureAdvancedThreatProtection`
The type of AzureAdvancedThreatProtection configuration.

To use this variant, set the property `name` to `AzureAdvancedThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-azureadvancedthreatprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-azureadvancedthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-AzureAdvancedThreatProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureAdvancedThreatProtection'
  ]
  ```

### Parameter: `connectors.name-AzureAdvancedThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-azureadvancedthreatprotectionpropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-connectorsname-azureadvancedthreatprotectionpropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `connectors.name-AzureAdvancedThreatProtection.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-azureadvancedthreatprotectionpropertiesdatatypesalerts) | object | Alerts data type connection. |

### Parameter: `connectors.name-AzureAdvancedThreatProtection.properties.dataTypes.alerts`

Alerts data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-azureadvancedthreatprotectionpropertiesdatatypesalertsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `connectors.name-AzureAdvancedThreatProtection.properties.dataTypes.alerts.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AzureAdvancedThreatProtection.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `connectors.name-AzureSecurityCenter`
The type of AzureSecurityCenter configuration.

To use this variant, set the property `name` to `AzureSecurityCenter`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-azuresecuritycentername) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-azuresecuritycenterproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-AzureSecurityCenter.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureSecurityCenter'
  ]
  ```

### Parameter: `connectors.name-AzureSecurityCenter.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-azuresecuritycenterpropertiesdatatypes) | object | The available data types for the connector. |
| [`subscriptionId`](#parameter-connectorsname-azuresecuritycenterpropertiessubscriptionid) | string | The subscription id to connect to, and get the data from. |

### Parameter: `connectors.name-AzureSecurityCenter.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-azuresecuritycenterpropertiesdatatypesalerts) | object | Data type for IOT data connector. |

### Parameter: `connectors.name-AzureSecurityCenter.properties.dataTypes.alerts`

Data type for IOT data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-azuresecuritycenterpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `connectors.name-AzureSecurityCenter.properties.dataTypes.alerts.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-AzureSecurityCenter.properties.subscriptionId`

The subscription id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `connectors.name-Dynamics365`
The type of Dynamics365 configuration.

To use this variant, set the property `name` to `Dynamics365`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-dynamics365name) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-dynamics365properties) | object | The properties of the data connector. |

### Parameter: `connectors.name-Dynamics365.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamics365'
  ]
  ```

### Parameter: `connectors.name-Dynamics365.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-dynamics365propertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-connectorsname-dynamics365propertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `connectors.name-Dynamics365.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamics365CdsActivities`](#parameter-connectorsname-dynamics365propertiesdatatypesdynamics365cdsactivities) | object | Common Data Service data type connection. |

### Parameter: `connectors.name-Dynamics365.properties.dataTypes.dynamics365CdsActivities`

Common Data Service data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-dynamics365propertiesdatatypesdynamics365cdsactivitiesstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `connectors.name-Dynamics365.properties.dataTypes.dynamics365CdsActivities.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-Dynamics365.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `connectors.name-GCP`
The type of GCP configuration.

To use this variant, set the property `name` to `GCP`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-gcpname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-gcpproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-GCP.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCP'
  ]
  ```

### Parameter: `connectors.name-GCP.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-connectorsname-gcppropertiesauth) | object | The authentication configuration for GCP. |
| [`connectorDefinitionName`](#parameter-connectorsname-gcppropertiesconnectordefinitionname) | string | The name of the connector definition. |
| [`dcrConfig`](#parameter-connectorsname-gcppropertiesdcrconfig) | object | The Data Collection Rule configuration. |
| [`request`](#parameter-connectorsname-gcppropertiesrequest) | object | The request configuration. |

### Parameter: `connectors.name-GCP.properties.auth`

The authentication configuration for GCP.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectNumber`](#parameter-connectorsname-gcppropertiesauthprojectnumber) | string | The GCP project number. |
| [`serviceAccountEmail`](#parameter-connectorsname-gcppropertiesauthserviceaccountemail) | string | The service account email address. |
| [`workloadIdentityProviderId`](#parameter-connectorsname-gcppropertiesauthworkloadidentityproviderid) | string | The workload identity provider ID. |

### Parameter: `connectors.name-GCP.properties.auth.projectNumber`

The GCP project number.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.auth.serviceAccountEmail`

The service account email address.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.auth.workloadIdentityProviderId`

The workload identity provider ID.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.connectorDefinitionName`

The name of the connector definition.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.dcrConfig`

The Data Collection Rule configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpoint`](#parameter-connectorsname-gcppropertiesdcrconfigdatacollectionendpoint) | string | The data collection endpoint. |
| [`dataCollectionRuleImmutableId`](#parameter-connectorsname-gcppropertiesdcrconfigdatacollectionruleimmutableid) | string | The immutable ID of the data collection rule. |
| [`streamName`](#parameter-connectorsname-gcppropertiesdcrconfigstreamname) | string | The name of the data stream. |

### Parameter: `connectors.name-GCP.properties.dcrConfig.dataCollectionEndpoint`

The data collection endpoint.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.dcrConfig.dataCollectionRuleImmutableId`

The immutable ID of the data collection rule.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.dcrConfig.streamName`

The name of the data stream.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectId`](#parameter-connectorsname-gcppropertiesrequestprojectid) | string | The GCP project ID. |
| [`subscriptionNames`](#parameter-connectorsname-gcppropertiesrequestsubscriptionnames) | array | The list of subscription names. |

### Parameter: `connectors.name-GCP.properties.request.projectId`

The GCP project ID.

- Required: Yes
- Type: string

### Parameter: `connectors.name-GCP.properties.request.subscriptionNames`

The list of subscription names.

- Required: Yes
- Type: array

### Variant: `connectors.name-GenericUI`
The type of Generic UI configuration.

To use this variant, set the property `name` to `GenericUI`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-genericuiname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-genericuiproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-GenericUI.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GenericUI'
  ]
  ```

### Parameter: `connectors.name-GenericUI.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectivityCriteria`](#parameter-connectorsname-genericuipropertiesconnectivitycriteria) | array | The criteria for connector connectivity validation. |
| [`dataTypes`](#parameter-connectorsname-genericuipropertiesdatatypes) | object | The data types for the connector. |

### Parameter: `connectors.name-GenericUI.properties.connectivityCriteria`

The criteria for connector connectivity validation.

- Required: Yes
- Type: array

### Parameter: `connectors.name-GenericUI.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-genericuipropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `connectors.name-GenericUI.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-genericuipropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-GenericUI.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Variant: `connectors.name-IOT`
The type of IOT configuration.

To use this variant, set the property `name` to `IOT`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-iotname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-iotproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-IOT.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IOT'
  ]
  ```

### Parameter: `connectors.name-IOT.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-iotpropertiesdatatypes) | object | The available data types for the connector. |
| [`subscriptionId`](#parameter-connectorsname-iotpropertiessubscriptionid) | string | The subscription id to connect to, and get the data from. |

### Parameter: `connectors.name-IOT.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-iotpropertiesdatatypesalerts) | object | Data type for IOT data connector. |

### Parameter: `connectors.name-IOT.properties.dataTypes.alerts`

Data type for IOT data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-iotpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `connectors.name-IOT.properties.dataTypes.alerts.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `connectors.name-IOT.properties.subscriptionId`

The subscription id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `connectors.name-MicrosoftCloudAppSecurity`
The type of Microsoft Cloud App Security configuration.

To use this variant, set the property `name` to `MicrosoftCloudAppSecurity`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-microsoftcloudappsecurityname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-microsoftcloudappsecurityproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftCloudAppSecurity'
  ]
  ```

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-microsoftcloudappsecuritypropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-microsoftcloudappsecuritypropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-microsoftcloudappsecuritypropertiesdatatypesalerts) | object | The alerts configuration. |
| [`discovery`](#parameter-connectorsname-microsoftcloudappsecuritypropertiesdatatypesdiscovery) | object | The discovery configuration. |

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-microsoftcloudappsecuritypropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties.dataTypes.discovery`

The discovery configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-microsoftcloudappsecuritypropertiesdatatypesdiscoverystate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties.dataTypes.discovery.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftCloudAppSecurity.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-MicrosoftDefenderAdvancedThreatProtection`
The type of Microsoft Defender Advanced Threat Protection configuration.

To use this variant, set the property `name` to `MicrosoftDefenderAdvancedThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-microsoftdefenderadvancedthreatprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-microsoftdefenderadvancedthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-MicrosoftDefenderAdvancedThreatProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftDefenderAdvancedThreatProtection'
  ]
  ```

### Parameter: `connectors.name-MicrosoftDefenderAdvancedThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-microsoftdefenderadvancedthreatprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-microsoftdefenderadvancedthreatprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-microsoftdefenderadvancedthreatprotectionpropertiesdatatypesalerts) | object | The alerts configuration. |

### Parameter: `connectors.name-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-microsoftdefenderadvancedthreatprotectionpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftDefenderAdvancedThreatProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-MicrosoftPurviewInformationProtection`
The type of Microsoft Purview Information Protection configuration.

To use this variant, set the property `name` to `MicrosoftPurviewInformationProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-microsoftpurviewinformationprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-microsoftpurviewinformationprotectionproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-MicrosoftPurviewInformationProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftPurviewInformationProtection'
  ]
  ```

### Parameter: `connectors.name-MicrosoftPurviewInformationProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-microsoftpurviewinformationprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-microsoftpurviewinformationprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-MicrosoftPurviewInformationProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`incidents`](#parameter-connectorsname-microsoftpurviewinformationprotectionpropertiesdatatypesincidents) | object | The incidents configuration. |

### Parameter: `connectors.name-MicrosoftPurviewInformationProtection.properties.dataTypes.incidents`

The incidents configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-microsoftpurviewinformationprotectionpropertiesdatatypesincidentsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-MicrosoftPurviewInformationProtection.properties.dataTypes.incidents.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftPurviewInformationProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

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

### Variant: `connectors.name-MicrosoftThreatProtection`
The type of Microsoft Threat Protection configuration.

To use this variant, set the property `name` to `MicrosoftThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-microsoftthreatprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-microsoftthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-MicrosoftThreatProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftThreatProtection'
  ]
  ```

### Parameter: `connectors.name-MicrosoftThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-microsoftthreatprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-microsoftthreatprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-MicrosoftThreatProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`incidents`](#parameter-connectorsname-microsoftthreatprotectionpropertiesdatatypesincidents) | object | The incidents configuration. |

### Parameter: `connectors.name-MicrosoftThreatProtection.properties.dataTypes.incidents`

The incidents configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-microsoftthreatprotectionpropertiesdatatypesincidentsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-MicrosoftThreatProtection.properties.dataTypes.incidents.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-MicrosoftThreatProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-Office365`
The type of Office 365 configuration.

To use this variant, set the property `name` to `Office365`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-office365name) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-office365properties) | object | The properties of the data connector. |

### Parameter: `connectors.name-Office365.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Office365'
  ]
  ```

### Parameter: `connectors.name-Office365.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-office365propertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-office365propertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-Office365.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exchange`](#parameter-connectorsname-office365propertiesdatatypesexchange) | object | The Exchange configuration. |
| [`sharePoint`](#parameter-connectorsname-office365propertiesdatatypessharepoint) | object | The SharePoint configuration. |
| [`teams`](#parameter-connectorsname-office365propertiesdatatypesteams) | object | The Teams configuration. |

### Parameter: `connectors.name-Office365.properties.dataTypes.exchange`

The Exchange configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-office365propertiesdatatypesexchangestate) | string | Whether the Exchange connection is enabled. |

### Parameter: `connectors.name-Office365.properties.dataTypes.exchange.state`

Whether the Exchange connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-Office365.properties.dataTypes.sharePoint`

The SharePoint configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-office365propertiesdatatypessharepointstate) | string | Whether the SharePoint connection is enabled. |

### Parameter: `connectors.name-Office365.properties.dataTypes.sharePoint.state`

Whether the SharePoint connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-Office365.properties.dataTypes.teams`

The Teams configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-office365propertiesdatatypesteamsstate) | string | Whether the Teams connection is enabled. |

### Parameter: `connectors.name-Office365.properties.dataTypes.teams.state`

Whether the Teams connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-Office365.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-Office365Project`
The type of Office 365 Project configuration.

To use this variant, set the property `name` to `Office365Project`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-office365projectname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-office365projectproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-Office365Project.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Office365Project'
  ]
  ```

### Parameter: `connectors.name-Office365Project.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-office365projectpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-office365projectpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-Office365Project.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-office365projectpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `connectors.name-Office365Project.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-office365projectpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-Office365Project.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-Office365Project.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-OfficeATP`
The type of Office ATP configuration.

To use this variant, set the property `name` to `OfficeATP`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-officeatpname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-officeatpproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-OfficeATP.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficeATP'
  ]
  ```

### Parameter: `connectors.name-OfficeATP.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-officeatppropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-officeatppropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-OfficeATP.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-connectorsname-officeatppropertiesdatatypesalerts) | object | The alerts configuration. |

### Parameter: `connectors.name-OfficeATP.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-officeatppropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-OfficeATP.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-OfficeATP.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-OfficeIRM`
The type of Office IRM configuration.

To use this variant, set the property `name` to `OfficeIRM`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-officeirmname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-officeirmproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-OfficeIRM.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficeIRM'
  ]
  ```

### Parameter: `connectors.name-OfficeIRM.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-officeirmpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-officeirmpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-OfficeIRM.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-officeirmpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `connectors.name-OfficeIRM.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-officeirmpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-OfficeIRM.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-OfficeIRM.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-OfficePowerBI`
The type of Office Power BI configuration.

To use this variant, set the property `name` to `OfficePowerBI`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-officepowerbiname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-officepowerbiproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-OfficePowerBI.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficePowerBI'
  ]
  ```

### Parameter: `connectors.name-OfficePowerBI.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-officepowerbipropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-officepowerbipropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-OfficePowerBI.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-officepowerbipropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `connectors.name-OfficePowerBI.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-officepowerbipropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-OfficePowerBI.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-OfficePowerBI.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-PurviewAudit`
The type of Purview Audit configuration.

To use this variant, set the property `name` to `PurviewAudit`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-purviewauditname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-purviewauditproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-PurviewAudit.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PurviewAudit'
  ]
  ```

### Parameter: `connectors.name-PurviewAudit.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-purviewauditpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-connectorsname-purviewauditpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `connectors.name-PurviewAudit.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-connectorsname-purviewauditpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `connectors.name-PurviewAudit.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-connectorsname-purviewauditpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `connectors.name-PurviewAudit.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-PurviewAudit.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `connectors.name-RestApiPoller`
The type of REST API Poller configuration.

To use this variant, set the property `name` to `RestApiPoller`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-restapipollername) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-restapipollerproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-RestApiPoller.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'RestApiPoller'
  ]
  ```

### Parameter: `connectors.name-RestApiPoller.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parseMappings`](#parameter-connectorsname-restapipollerpropertiesparsemappings) | array | The parsing rules for the response. |
| [`pollingConfig`](#parameter-connectorsname-restapipollerpropertiespollingconfig) | object | The polling configuration for the data connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-connectorsname-restapipollerpropertieslookbackperiod) | string | The lookback period for historical data. |

### Parameter: `connectors.name-RestApiPoller.properties.parseMappings`

The parsing rules for the response.

- Required: Yes
- Type: array

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig`

The polling configuration for the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-connectorsname-restapipollerpropertiespollingconfigauth) | object | The authentication configuration. |
| [`request`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequest) | object | The request configuration. |

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.auth`

The authentication configuration.

- Required: Yes
- Type: object

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoint`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequestendpoint) | string | The API endpoint to poll. |
| [`method`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequestmethod) | string | The HTTP method to use. |
| [`rateLimitQps`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequestratelimitqps) | int | Rate limit in queries per second. |
| [`timeout`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequesttimeout) | string | Request timeout duration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`headers`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequestheaders) | object | Additional headers to include in the request. |
| [`queryParameters`](#parameter-connectorsname-restapipollerpropertiespollingconfigrequestqueryparameters) | object | Query parameters to include in the request. |

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request.endpoint`

The API endpoint to poll.

- Required: Yes
- Type: string

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request.method`

The HTTP method to use.

- Required: Yes
- Type: string

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request.rateLimitQps`

Rate limit in queries per second.

- Required: Yes
- Type: int

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request.timeout`

Request timeout duration.

- Required: Yes
- Type: string

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request.headers`

Additional headers to include in the request.

- Required: No
- Type: object

### Parameter: `connectors.name-RestApiPoller.properties.pollingConfig.request.queryParameters`

Query parameters to include in the request.

- Required: No
- Type: object

### Parameter: `connectors.name-RestApiPoller.properties.lookbackPeriod`

The lookback period for historical data.

- Required: No
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
| [`state`](#parameter-connectorsname-threatintelligencepropertiesdatatypesindicatorsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `connectors.name-ThreatIntelligence.properties.dataTypes.indicators.state`

Whether this data type connection is enabled or not.

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

### Variant: `connectors.name-ThreatIntelligenceTaxii`
The type of Threat Intelligence TAXII configuration.

To use this variant, set the property `name` to `ThreatIntelligenceTaxii`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectorsname-threatintelligencetaxiiname) | string | The type of data connector. |
| [`properties`](#parameter-connectorsname-threatintelligencetaxiiproperties) | object | The properties of the data connector. |

### Parameter: `connectors.name-ThreatIntelligenceTaxii.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ThreatIntelligenceTaxii'
  ]
  ```

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypes) | object | The data types for the connector. |

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`taxiiClient`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclient) | object | The TAXII client configuration. |

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient`

The TAXII client configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`collectionId`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclientcollectionid) | string | The collection ID to fetch from. |
| [`state`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclientstate) | string | Whether this connection is enabled. |
| [`taxiiServer`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclienttaxiiserver) | string | The TAXII server URL. |
| [`workspaceId`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclientworkspaceid) | string | The workspace ID for the connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`password`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclientpassword) | string | The password for authentication. |
| [`username`](#parameter-connectorsname-threatintelligencetaxiipropertiesdatatypestaxiiclientusername) | string | The username for authentication. |

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.collectionId`

The collection ID to fetch from.

- Required: Yes
- Type: string

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.state`

Whether this connection is enabled.

- Required: Yes
- Type: string

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.taxiiServer`

The TAXII server URL.

- Required: Yes
- Type: string

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.workspaceId`

The workspace ID for the connector.

- Required: Yes
- Type: string

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.password`

The password for authentication.

- Required: No
- Type: string

### Parameter: `connectors.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.username`

The username for authentication.

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

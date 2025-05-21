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
| `Microsoft.SecurityInsights/dataConnectors` | [2025-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2025-03-01/dataConnectors) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/security-insights/data-connector:<version>`.

- [Using defaults](#example-1-using-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
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
    name: 'MicrosoftThreatIntelligence'
    properties: {
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
    workspaceResourceId: '<workspaceResourceId>'
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
    "name": {
      "value": "MicrosoftThreatIntelligence"
    },
    "properties": {
      "value": {
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
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
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
param name = 'MicrosoftThreatIntelligence'
param properties = {
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
param workspaceResourceId = '<workspaceResourceId>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module dataConnector 'br/public:avm/res/security-insights/data-connector:<version>' = {
  name: 'dataConnectorDeployment'
  params: {
    // Required parameters
    name: 'MicrosoftThreatIntelligence'
    properties: {
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
    workspaceResourceId: '<workspaceResourceId>'
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
    "name": {
      "value": "MicrosoftThreatIntelligence"
    },
    "properties": {
      "value": {
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
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
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
using 'br/public:avm/res/security-insights/data-connector:<version>'

// Required parameters
param name = 'MicrosoftThreatIntelligence'
param properties = {
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
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
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
    name: 'MicrosoftThreatIntelligence'
    properties: {
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
    workspaceResourceId: '<workspaceResourceId>'
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
    "name": {
      "value": "MicrosoftThreatIntelligence"
    },
    "properties": {
      "value": {
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
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
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
param name = 'MicrosoftThreatIntelligence'
param properties = {
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
param workspaceResourceId = '<workspaceResourceId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the data connector. |
| [`properties`](#parameter-properties) | object | The data connector configuration. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |

### Parameter: `name`

The name of the data connector.

- Required: Yes
- Type: string

### Parameter: `properties`

The data connector configuration.

- Required: Yes
- Type: object
- Discriminator: `name`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`AmazonWebServicesCloudTrail`](#variant-propertiesname-amazonwebservicescloudtrail) | The type of AmazonWebServicesCloudTrail configuration. |
| [`AmazonWebServicesS3`](#variant-propertiesname-amazonwebservicess3) | The type of AmazonWebServicesS3 configuration. |
| [`APIPolling`](#variant-propertiesname-apipolling) | The type of API Polling configuration. |
| [`AzureActiveDirectory`](#variant-propertiesname-azureactivedirectory) | The type of AzureActiveDirectory configuration. |
| [`AzureAdvancedThreatProtection`](#variant-propertiesname-azureadvancedthreatprotection) | The type of AzureAdvancedThreatProtection configuration. |
| [`AzureSecurityCenter`](#variant-propertiesname-azuresecuritycenter) | The type of AzureSecurityCenter configuration. |
| [`Dynamics365`](#variant-propertiesname-dynamics365) | The type of Dynamics365 configuration. |
| [`GCP`](#variant-propertiesname-gcp) | The type of GCP configuration. |
| [`GenericUI`](#variant-propertiesname-genericui) | The type of Generic UI configuration. |
| [`IOT`](#variant-propertiesname-iot) | The type of IOT configuration. |
| [`MicrosoftCloudAppSecurity`](#variant-propertiesname-microsoftcloudappsecurity) | The type of Microsoft Cloud App Security configuration. |
| [`MicrosoftDefenderAdvancedThreatProtection`](#variant-propertiesname-microsoftdefenderadvancedthreatprotection) | The type of Microsoft Defender Advanced Threat Protection configuration. |
| [`MicrosoftPurviewInformationProtection`](#variant-propertiesname-microsoftpurviewinformationprotection) | The type of Microsoft Purview Information Protection configuration. |
| [`MicrosoftThreatIntelligence`](#variant-propertiesname-microsoftthreatintelligence) | The type of MicrosoftThreatIntelligenceType configuration. |
| [`MicrosoftThreatProtection`](#variant-propertiesname-microsoftthreatprotection) | The type of Microsoft Threat Protection configuration. |
| [`Office365`](#variant-propertiesname-office365) | The type of Office 365 configuration. |
| [`Office365Project`](#variant-propertiesname-office365project) | The type of Office 365 Project configuration. |
| [`OfficeATP`](#variant-propertiesname-officeatp) | The type of Office ATP configuration. |
| [`OfficeIRM`](#variant-propertiesname-officeirm) | The type of Office IRM configuration. |
| [`OfficePowerBI`](#variant-propertiesname-officepowerbi) | The type of Office Power BI configuration. |
| [`PurviewAudit`](#variant-propertiesname-purviewaudit) | The type of Purview Audit configuration. |
| [`RestApiPoller`](#variant-propertiesname-restapipoller) | The type of REST API Poller configuration. |
| [`ThreatIntelligence`](#variant-propertiesname-threatintelligence) | The type of ThreatIntelligenceType configuration. |
| [`ThreatIntelligenceTaxii`](#variant-propertiesname-threatintelligencetaxii) | The type of Threat Intelligence TAXII configuration. |

### Variant: `properties.name-AmazonWebServicesCloudTrail`
The type of AmazonWebServicesCloudTrail configuration.

To use this variant, set the property `name` to `AmazonWebServicesCloudTrail`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-amazonwebservicescloudtrailname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-amazonwebservicescloudtrailproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-AmazonWebServicesCloudTrail.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesCloudTrail'
  ]
  ```

### Parameter: `properties.name-AmazonWebServicesCloudTrail.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`awsRoleArn`](#parameter-propertiesname-amazonwebservicescloudtrailpropertiesawsrolearn) | string | The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account. |
| [`dataTypes`](#parameter-propertiesname-amazonwebservicescloudtrailpropertiesdatatypes) | object | The available data types for the connector. |

### Parameter: `properties.name-AmazonWebServicesCloudTrail.properties.awsRoleArn`

The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account.

- Required: Yes
- Type: string

### Parameter: `properties.name-AmazonWebServicesCloudTrail.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-amazonwebservicescloudtrailpropertiesdatatypeslogs) | object | Data type for Amazon Web Services Cloud Trail data connector. |

### Parameter: `properties.name-AmazonWebServicesCloudTrail.properties.dataTypes.logs`

Data type for Amazon Web Services Cloud Trail data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-amazonwebservicescloudtrailpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.name-AmazonWebServicesCloudTrail.properties.dataTypes.logs.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Variant: `properties.name-AmazonWebServicesS3`
The type of AmazonWebServicesS3 configuration.

To use this variant, set the property `name` to `AmazonWebServicesS3`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-amazonwebservicess3name) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-amazonwebservicess3properties) | object | The properties of the data connector. |

### Parameter: `properties.name-AmazonWebServicesS3.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesS3'
  ]
  ```

### Parameter: `properties.name-AmazonWebServicesS3.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-amazonwebservicess3propertiesdatatypes) | object | The available data types for the connector. |
| [`destinationTable`](#parameter-propertiesname-amazonwebservicess3propertiesdestinationtable) | string | The logs destination table name in LogAnalytics. |
| [`roleArn`](#parameter-propertiesname-amazonwebservicess3propertiesrolearn) | string | The AWS Role Arn that is used to access the Aws account. |
| [`sqsUrls`](#parameter-propertiesname-amazonwebservicess3propertiessqsurls) | array | The AWS sqs urls for the connector. |

### Parameter: `properties.name-AmazonWebServicesS3.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-amazonwebservicess3propertiesdatatypeslogs) | object | Data type for Amazon Web Services S3 data connector. |

### Parameter: `properties.name-AmazonWebServicesS3.properties.dataTypes.logs`

Data type for Amazon Web Services S3 data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-amazonwebservicess3propertiesdatatypeslogsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.name-AmazonWebServicesS3.properties.dataTypes.logs.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-AmazonWebServicesS3.properties.destinationTable`

The logs destination table name in LogAnalytics.

- Required: Yes
- Type: string

### Parameter: `properties.name-AmazonWebServicesS3.properties.roleArn`

The AWS Role Arn that is used to access the Aws account.

- Required: Yes
- Type: string

### Parameter: `properties.name-AmazonWebServicesS3.properties.sqsUrls`

The AWS sqs urls for the connector.

- Required: Yes
- Type: array

### Variant: `properties.name-APIPolling`
The type of API Polling configuration.

To use this variant, set the property `name` to `APIPolling`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-apipollingname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-apipollingproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-APIPolling.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'APIPolling'
  ]
  ```

### Parameter: `properties.name-APIPolling.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parseMappings`](#parameter-propertiesname-apipollingpropertiesparsemappings) | array | The parsing rules for the response. |
| [`pollingConfig`](#parameter-propertiesname-apipollingpropertiespollingconfig) | object | The polling configuration for the data connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-propertiesname-apipollingpropertieslookbackperiod) | string | The lookback period for historical data. |

### Parameter: `properties.name-APIPolling.properties.parseMappings`

The parsing rules for the response.

- Required: Yes
- Type: array

### Parameter: `properties.name-APIPolling.properties.pollingConfig`

The polling configuration for the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-propertiesname-apipollingpropertiespollingconfigauth) | object | The authentication configuration. |
| [`request`](#parameter-propertiesname-apipollingpropertiespollingconfigrequest) | object | The request configuration. |

### Parameter: `properties.name-APIPolling.properties.pollingConfig.auth`

The authentication configuration.

- Required: Yes
- Type: object

### Parameter: `properties.name-APIPolling.properties.pollingConfig.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoint`](#parameter-propertiesname-apipollingpropertiespollingconfigrequestendpoint) | string | The API endpoint to poll. |
| [`method`](#parameter-propertiesname-apipollingpropertiespollingconfigrequestmethod) | string | The HTTP method to use. |
| [`rateLimitQps`](#parameter-propertiesname-apipollingpropertiespollingconfigrequestratelimitqps) | int | Rate limit in queries per second. |
| [`timeout`](#parameter-propertiesname-apipollingpropertiespollingconfigrequesttimeout) | string | Request timeout duration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`queryParameters`](#parameter-propertiesname-apipollingpropertiespollingconfigrequestqueryparameters) | object | Query parameters to include in the request. |

### Parameter: `properties.name-APIPolling.properties.pollingConfig.request.endpoint`

The API endpoint to poll.

- Required: Yes
- Type: string

### Parameter: `properties.name-APIPolling.properties.pollingConfig.request.method`

The HTTP method to use.

- Required: Yes
- Type: string

### Parameter: `properties.name-APIPolling.properties.pollingConfig.request.rateLimitQps`

Rate limit in queries per second.

- Required: Yes
- Type: int

### Parameter: `properties.name-APIPolling.properties.pollingConfig.request.timeout`

Request timeout duration.

- Required: Yes
- Type: string

### Parameter: `properties.name-APIPolling.properties.pollingConfig.request.queryParameters`

Query parameters to include in the request.

- Required: No
- Type: object

### Parameter: `properties.name-APIPolling.properties.lookbackPeriod`

The lookback period for historical data.

- Required: No
- Type: string

### Variant: `properties.name-AzureActiveDirectory`
The type of AzureActiveDirectory configuration.

To use this variant, set the property `name` to `AzureActiveDirectory`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-azureactivedirectoryname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-azureactivedirectoryproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-AzureActiveDirectory.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureActiveDirectory'
  ]
  ```

### Parameter: `properties.name-AzureActiveDirectory.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-azureactivedirectorypropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertiesname-azureactivedirectorypropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.name-AzureActiveDirectory.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-azureactivedirectorypropertiesdatatypesalerts) | object | Alerts data type connection. |

### Parameter: `properties.name-AzureActiveDirectory.properties.dataTypes.alerts`

Alerts data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-azureactivedirectorypropertiesdatatypesalertsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `properties.name-AzureActiveDirectory.properties.dataTypes.alerts.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-AzureActiveDirectory.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.name-AzureAdvancedThreatProtection`
The type of AzureAdvancedThreatProtection configuration.

To use this variant, set the property `name` to `AzureAdvancedThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-azureadvancedthreatprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-azureadvancedthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-AzureAdvancedThreatProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureAdvancedThreatProtection'
  ]
  ```

### Parameter: `properties.name-AzureAdvancedThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-azureadvancedthreatprotectionpropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertiesname-azureadvancedthreatprotectionpropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.name-AzureAdvancedThreatProtection.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-azureadvancedthreatprotectionpropertiesdatatypesalerts) | object | Alerts data type connection. |

### Parameter: `properties.name-AzureAdvancedThreatProtection.properties.dataTypes.alerts`

Alerts data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-azureadvancedthreatprotectionpropertiesdatatypesalertsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `properties.name-AzureAdvancedThreatProtection.properties.dataTypes.alerts.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-AzureAdvancedThreatProtection.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.name-AzureSecurityCenter`
The type of AzureSecurityCenter configuration.

To use this variant, set the property `name` to `AzureSecurityCenter`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-azuresecuritycentername) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-azuresecuritycenterproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-AzureSecurityCenter.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureSecurityCenter'
  ]
  ```

### Parameter: `properties.name-AzureSecurityCenter.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-azuresecuritycenterpropertiesdatatypes) | object | The available data types for the connector. |
| [`subscriptionId`](#parameter-propertiesname-azuresecuritycenterpropertiessubscriptionid) | string | The subscription id to connect to, and get the data from. |

### Parameter: `properties.name-AzureSecurityCenter.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-azuresecuritycenterpropertiesdatatypesalerts) | object | Data type for IOT data connector. |

### Parameter: `properties.name-AzureSecurityCenter.properties.dataTypes.alerts`

Data type for IOT data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-azuresecuritycenterpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.name-AzureSecurityCenter.properties.dataTypes.alerts.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-AzureSecurityCenter.properties.subscriptionId`

The subscription id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.name-Dynamics365`
The type of Dynamics365 configuration.

To use this variant, set the property `name` to `Dynamics365`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-dynamics365name) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-dynamics365properties) | object | The properties of the data connector. |

### Parameter: `properties.name-Dynamics365.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamics365'
  ]
  ```

### Parameter: `properties.name-Dynamics365.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-dynamics365propertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertiesname-dynamics365propertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.name-Dynamics365.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamics365CdsActivities`](#parameter-propertiesname-dynamics365propertiesdatatypesdynamics365cdsactivities) | object | Common Data Service data type connection. |

### Parameter: `properties.name-Dynamics365.properties.dataTypes.dynamics365CdsActivities`

Common Data Service data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-dynamics365propertiesdatatypesdynamics365cdsactivitiesstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `properties.name-Dynamics365.properties.dataTypes.dynamics365CdsActivities.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-Dynamics365.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.name-GCP`
The type of GCP configuration.

To use this variant, set the property `name` to `GCP`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-gcpname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-gcpproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-GCP.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCP'
  ]
  ```

### Parameter: `properties.name-GCP.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-propertiesname-gcppropertiesauth) | object | The authentication configuration for GCP. |
| [`connectorDefinitionName`](#parameter-propertiesname-gcppropertiesconnectordefinitionname) | string | The name of the connector definition. |
| [`dcrConfig`](#parameter-propertiesname-gcppropertiesdcrconfig) | object | The Data Collection Rule configuration. |
| [`request`](#parameter-propertiesname-gcppropertiesrequest) | object | The request configuration. |

### Parameter: `properties.name-GCP.properties.auth`

The authentication configuration for GCP.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectNumber`](#parameter-propertiesname-gcppropertiesauthprojectnumber) | string | The GCP project number. |
| [`serviceAccountEmail`](#parameter-propertiesname-gcppropertiesauthserviceaccountemail) | string | The service account email address. |
| [`workloadIdentityProviderId`](#parameter-propertiesname-gcppropertiesauthworkloadidentityproviderid) | string | The workload identity provider ID. |

### Parameter: `properties.name-GCP.properties.auth.projectNumber`

The GCP project number.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.auth.serviceAccountEmail`

The service account email address.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.auth.workloadIdentityProviderId`

The workload identity provider ID.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.connectorDefinitionName`

The name of the connector definition.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.dcrConfig`

The Data Collection Rule configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpoint`](#parameter-propertiesname-gcppropertiesdcrconfigdatacollectionendpoint) | string | The data collection endpoint. |
| [`dataCollectionRuleImmutableId`](#parameter-propertiesname-gcppropertiesdcrconfigdatacollectionruleimmutableid) | string | The immutable ID of the data collection rule. |
| [`streamName`](#parameter-propertiesname-gcppropertiesdcrconfigstreamname) | string | The name of the data stream. |

### Parameter: `properties.name-GCP.properties.dcrConfig.dataCollectionEndpoint`

The data collection endpoint.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.dcrConfig.dataCollectionRuleImmutableId`

The immutable ID of the data collection rule.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.dcrConfig.streamName`

The name of the data stream.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectId`](#parameter-propertiesname-gcppropertiesrequestprojectid) | string | The GCP project ID. |
| [`subscriptionNames`](#parameter-propertiesname-gcppropertiesrequestsubscriptionnames) | array | The list of subscription names. |

### Parameter: `properties.name-GCP.properties.request.projectId`

The GCP project ID.

- Required: Yes
- Type: string

### Parameter: `properties.name-GCP.properties.request.subscriptionNames`

The list of subscription names.

- Required: Yes
- Type: array

### Variant: `properties.name-GenericUI`
The type of Generic UI configuration.

To use this variant, set the property `name` to `GenericUI`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-genericuiname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-genericuiproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-GenericUI.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GenericUI'
  ]
  ```

### Parameter: `properties.name-GenericUI.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectivityCriteria`](#parameter-propertiesname-genericuipropertiesconnectivitycriteria) | array | The criteria for connector connectivity validation. |
| [`dataTypes`](#parameter-propertiesname-genericuipropertiesdatatypes) | object | The data types for the connector. |

### Parameter: `properties.name-GenericUI.properties.connectivityCriteria`

The criteria for connector connectivity validation.

- Required: Yes
- Type: array

### Parameter: `properties.name-GenericUI.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-genericuipropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.name-GenericUI.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-genericuipropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-GenericUI.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Variant: `properties.name-IOT`
The type of IOT configuration.

To use this variant, set the property `name` to `IOT`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-iotname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-iotproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-IOT.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IOT'
  ]
  ```

### Parameter: `properties.name-IOT.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-iotpropertiesdatatypes) | object | The available data types for the connector. |
| [`subscriptionId`](#parameter-propertiesname-iotpropertiessubscriptionid) | string | The subscription id to connect to, and get the data from. |

### Parameter: `properties.name-IOT.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-iotpropertiesdatatypesalerts) | object | Data type for IOT data connector. |

### Parameter: `properties.name-IOT.properties.dataTypes.alerts`

Data type for IOT data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-iotpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.name-IOT.properties.dataTypes.alerts.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-IOT.properties.subscriptionId`

The subscription id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.name-MicrosoftCloudAppSecurity`
The type of Microsoft Cloud App Security configuration.

To use this variant, set the property `name` to `MicrosoftCloudAppSecurity`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-microsoftcloudappsecurityname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-microsoftcloudappsecurityproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-MicrosoftCloudAppSecurity.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftCloudAppSecurity'
  ]
  ```

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-microsoftcloudappsecuritypropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-microsoftcloudappsecuritypropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-microsoftcloudappsecuritypropertiesdatatypesalerts) | object | The alerts configuration. |
| [`discovery`](#parameter-propertiesname-microsoftcloudappsecuritypropertiesdatatypesdiscovery) | object | The discovery configuration. |

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-microsoftcloudappsecuritypropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties.dataTypes.discovery`

The discovery configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-microsoftcloudappsecuritypropertiesdatatypesdiscoverystate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties.dataTypes.discovery.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftCloudAppSecurity.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-MicrosoftDefenderAdvancedThreatProtection`
The type of Microsoft Defender Advanced Threat Protection configuration.

To use this variant, set the property `name` to `MicrosoftDefenderAdvancedThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-microsoftdefenderadvancedthreatprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-microsoftdefenderadvancedthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-MicrosoftDefenderAdvancedThreatProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftDefenderAdvancedThreatProtection'
  ]
  ```

### Parameter: `properties.name-MicrosoftDefenderAdvancedThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-microsoftdefenderadvancedthreatprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-microsoftdefenderadvancedthreatprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-microsoftdefenderadvancedthreatprotectionpropertiesdatatypesalerts) | object | The alerts configuration. |

### Parameter: `properties.name-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-microsoftdefenderadvancedthreatprotectionpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftDefenderAdvancedThreatProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-MicrosoftPurviewInformationProtection`
The type of Microsoft Purview Information Protection configuration.

To use this variant, set the property `name` to `MicrosoftPurviewInformationProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-microsoftpurviewinformationprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-microsoftpurviewinformationprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-MicrosoftPurviewInformationProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftPurviewInformationProtection'
  ]
  ```

### Parameter: `properties.name-MicrosoftPurviewInformationProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-microsoftpurviewinformationprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-microsoftpurviewinformationprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-MicrosoftPurviewInformationProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`incidents`](#parameter-propertiesname-microsoftpurviewinformationprotectionpropertiesdatatypesincidents) | object | The incidents configuration. |

### Parameter: `properties.name-MicrosoftPurviewInformationProtection.properties.dataTypes.incidents`

The incidents configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-microsoftpurviewinformationprotectionpropertiesdatatypesincidentsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-MicrosoftPurviewInformationProtection.properties.dataTypes.incidents.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftPurviewInformationProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-MicrosoftThreatIntelligence`
The type of MicrosoftThreatIntelligenceType configuration.

To use this variant, set the property `name` to `MicrosoftThreatIntelligence`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-microsoftthreatintelligencename) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-microsoftthreatintelligenceproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-MicrosoftThreatIntelligence.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftThreatIntelligence'
  ]
  ```

### Parameter: `properties.name-MicrosoftThreatIntelligence.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-microsoftthreatintelligencepropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertiesname-microsoftthreatintelligencepropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.name-MicrosoftThreatIntelligence.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`microsoftEmergingThreatFeed`](#parameter-propertiesname-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeed) | object | Data type for Microsoft Threat Intelligence Platforms data connector. |

### Parameter: `properties.name-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed`

Data type for Microsoft Threat Intelligence Platforms data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-propertiesname-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeedlookbackperiod) | string | The lookback period for the feed to be imported. |
| [`state`](#parameter-propertiesname-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeedstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.name-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed.lookbackPeriod`

The lookback period for the feed to be imported.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftThreatIntelligence.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.name-MicrosoftThreatProtection`
The type of Microsoft Threat Protection configuration.

To use this variant, set the property `name` to `MicrosoftThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-microsoftthreatprotectionname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-microsoftthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-MicrosoftThreatProtection.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftThreatProtection'
  ]
  ```

### Parameter: `properties.name-MicrosoftThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-microsoftthreatprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-microsoftthreatprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-MicrosoftThreatProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`incidents`](#parameter-propertiesname-microsoftthreatprotectionpropertiesdatatypesincidents) | object | The incidents configuration. |

### Parameter: `properties.name-MicrosoftThreatProtection.properties.dataTypes.incidents`

The incidents configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-microsoftthreatprotectionpropertiesdatatypesincidentsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-MicrosoftThreatProtection.properties.dataTypes.incidents.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-MicrosoftThreatProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-Office365`
The type of Office 365 configuration.

To use this variant, set the property `name` to `Office365`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-office365name) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-office365properties) | object | The properties of the data connector. |

### Parameter: `properties.name-Office365.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Office365'
  ]
  ```

### Parameter: `properties.name-Office365.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-office365propertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-office365propertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-Office365.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exchange`](#parameter-propertiesname-office365propertiesdatatypesexchange) | object | The Exchange configuration. |
| [`sharePoint`](#parameter-propertiesname-office365propertiesdatatypessharepoint) | object | The SharePoint configuration. |
| [`teams`](#parameter-propertiesname-office365propertiesdatatypesteams) | object | The Teams configuration. |

### Parameter: `properties.name-Office365.properties.dataTypes.exchange`

The Exchange configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-office365propertiesdatatypesexchangestate) | string | Whether the Exchange connection is enabled. |

### Parameter: `properties.name-Office365.properties.dataTypes.exchange.state`

Whether the Exchange connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-Office365.properties.dataTypes.sharePoint`

The SharePoint configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-office365propertiesdatatypessharepointstate) | string | Whether the SharePoint connection is enabled. |

### Parameter: `properties.name-Office365.properties.dataTypes.sharePoint.state`

Whether the SharePoint connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-Office365.properties.dataTypes.teams`

The Teams configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-office365propertiesdatatypesteamsstate) | string | Whether the Teams connection is enabled. |

### Parameter: `properties.name-Office365.properties.dataTypes.teams.state`

Whether the Teams connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-Office365.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-Office365Project`
The type of Office 365 Project configuration.

To use this variant, set the property `name` to `Office365Project`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-office365projectname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-office365projectproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-Office365Project.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Office365Project'
  ]
  ```

### Parameter: `properties.name-Office365Project.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-office365projectpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-office365projectpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-Office365Project.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-office365projectpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.name-Office365Project.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-office365projectpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-Office365Project.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-Office365Project.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-OfficeATP`
The type of Office ATP configuration.

To use this variant, set the property `name` to `OfficeATP`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-officeatpname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-officeatpproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-OfficeATP.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficeATP'
  ]
  ```

### Parameter: `properties.name-OfficeATP.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-officeatppropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-officeatppropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-OfficeATP.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertiesname-officeatppropertiesdatatypesalerts) | object | The alerts configuration. |

### Parameter: `properties.name-OfficeATP.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-officeatppropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-OfficeATP.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-OfficeATP.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-OfficeIRM`
The type of Office IRM configuration.

To use this variant, set the property `name` to `OfficeIRM`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-officeirmname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-officeirmproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-OfficeIRM.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficeIRM'
  ]
  ```

### Parameter: `properties.name-OfficeIRM.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-officeirmpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-officeirmpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-OfficeIRM.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-officeirmpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.name-OfficeIRM.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-officeirmpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-OfficeIRM.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-OfficeIRM.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-OfficePowerBI`
The type of Office Power BI configuration.

To use this variant, set the property `name` to `OfficePowerBI`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-officepowerbiname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-officepowerbiproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-OfficePowerBI.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficePowerBI'
  ]
  ```

### Parameter: `properties.name-OfficePowerBI.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-officepowerbipropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-officepowerbipropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-OfficePowerBI.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-officepowerbipropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.name-OfficePowerBI.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-officepowerbipropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-OfficePowerBI.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-OfficePowerBI.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-PurviewAudit`
The type of Purview Audit configuration.

To use this variant, set the property `name` to `PurviewAudit`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-purviewauditname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-purviewauditproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-PurviewAudit.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PurviewAudit'
  ]
  ```

### Parameter: `properties.name-PurviewAudit.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-purviewauditpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertiesname-purviewauditpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.name-PurviewAudit.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertiesname-purviewauditpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.name-PurviewAudit.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-purviewauditpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.name-PurviewAudit.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-PurviewAudit.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.name-RestApiPoller`
The type of REST API Poller configuration.

To use this variant, set the property `name` to `RestApiPoller`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-restapipollername) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-restapipollerproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-RestApiPoller.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'RestApiPoller'
  ]
  ```

### Parameter: `properties.name-RestApiPoller.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parseMappings`](#parameter-propertiesname-restapipollerpropertiesparsemappings) | array | The parsing rules for the response. |
| [`pollingConfig`](#parameter-propertiesname-restapipollerpropertiespollingconfig) | object | The polling configuration for the data connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-propertiesname-restapipollerpropertieslookbackperiod) | string | The lookback period for historical data. |

### Parameter: `properties.name-RestApiPoller.properties.parseMappings`

The parsing rules for the response.

- Required: Yes
- Type: array

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig`

The polling configuration for the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-propertiesname-restapipollerpropertiespollingconfigauth) | object | The authentication configuration. |
| [`request`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequest) | object | The request configuration. |

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.auth`

The authentication configuration.

- Required: Yes
- Type: object

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoint`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequestendpoint) | string | The API endpoint to poll. |
| [`method`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequestmethod) | string | The HTTP method to use. |
| [`rateLimitQps`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequestratelimitqps) | int | Rate limit in queries per second. |
| [`timeout`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequesttimeout) | string | Request timeout duration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`headers`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequestheaders) | object | Additional headers to include in the request. |
| [`queryParameters`](#parameter-propertiesname-restapipollerpropertiespollingconfigrequestqueryparameters) | object | Query parameters to include in the request. |

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request.endpoint`

The API endpoint to poll.

- Required: Yes
- Type: string

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request.method`

The HTTP method to use.

- Required: Yes
- Type: string

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request.rateLimitQps`

Rate limit in queries per second.

- Required: Yes
- Type: int

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request.timeout`

Request timeout duration.

- Required: Yes
- Type: string

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request.headers`

Additional headers to include in the request.

- Required: No
- Type: object

### Parameter: `properties.name-RestApiPoller.properties.pollingConfig.request.queryParameters`

Query parameters to include in the request.

- Required: No
- Type: object

### Parameter: `properties.name-RestApiPoller.properties.lookbackPeriod`

The lookback period for historical data.

- Required: No
- Type: string

### Variant: `properties.name-ThreatIntelligence`
The type of ThreatIntelligenceType configuration.

To use this variant, set the property `name` to `ThreatIntelligence`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-threatintelligencename) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-threatintelligenceproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-ThreatIntelligence.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ThreatIntelligence'
  ]
  ```

### Parameter: `properties.name-ThreatIntelligence.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-threatintelligencepropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertiesname-threatintelligencepropertiestenantid) | string | The tenant id to connect to, and get the data from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tipLookbackPeriod`](#parameter-propertiesname-threatintelligencepropertiestiplookbackperiod) | string | The lookback period for the feed to be imported. |

### Parameter: `properties.name-ThreatIntelligence.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indicators`](#parameter-propertiesname-threatintelligencepropertiesdatatypesindicators) | object | Data type for indicators connection. |

### Parameter: `properties.name-ThreatIntelligence.properties.dataTypes.indicators`

Data type for indicators connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertiesname-threatintelligencepropertiesdatatypesindicatorsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.name-ThreatIntelligence.properties.dataTypes.indicators.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.name-ThreatIntelligence.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Parameter: `properties.name-ThreatIntelligence.properties.tipLookbackPeriod`

The lookback period for the feed to be imported.

- Required: No
- Type: string

### Variant: `properties.name-ThreatIntelligenceTaxii`
The type of Threat Intelligence TAXII configuration.

To use this variant, set the property `name` to `ThreatIntelligenceTaxii`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-propertiesname-threatintelligencetaxiiname) | string | The type of data connector. |
| [`properties`](#parameter-propertiesname-threatintelligencetaxiiproperties) | object | The properties of the data connector. |

### Parameter: `properties.name-ThreatIntelligenceTaxii.name`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ThreatIntelligenceTaxii'
  ]
  ```

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypes) | object | The data types for the connector. |

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`taxiiClient`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclient) | object | The TAXII client configuration. |

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient`

The TAXII client configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`collectionId`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclientcollectionid) | string | The collection ID to fetch from. |
| [`state`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclientstate) | string | Whether this connection is enabled. |
| [`taxiiServer`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclienttaxiiserver) | string | The TAXII server URL. |
| [`workspaceId`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclientworkspaceid) | string | The workspace ID for the connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`password`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclientpassword) | string | The password for authentication. |
| [`username`](#parameter-propertiesname-threatintelligencetaxiipropertiesdatatypestaxiiclientusername) | string | The username for authentication. |

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.collectionId`

The collection ID to fetch from.

- Required: Yes
- Type: string

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.state`

Whether this connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.taxiiServer`

The TAXII server URL.

- Required: Yes
- Type: string

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.workspaceId`

The workspace ID for the connector.

- Required: Yes
- Type: string

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.password`

The password for authentication.

- Required: No
- Type: string

### Parameter: `properties.name-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.username`

The username for authentication.

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
| `name` | string | The name of the deployed data connector. |
| `resourceGroupName` | string | The resource group where the Security Insights Data Connector is deployed. |
| `resourceId` | string | The resource ID of the deployed data connector. |
| `resourceType` | string | The resource type of the deployed data connector. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity of the deployed data connector. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

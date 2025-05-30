# Security Insights Data Connectors `[Microsoft.SecurityInsights/dataConnectors]`

This module deploys a Security Insights Data Connector.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
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
    properties: {
      kind: 'MicrosoftThreatIntelligence'
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
    name: 'MicrosoftThreatIntelligence'
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
    "properties": {
      "value": {
        "kind": "MicrosoftThreatIntelligence",
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
    "name": {
      "value": "MicrosoftThreatIntelligence"
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
param properties = {
  kind: 'MicrosoftThreatIntelligence'
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
param name = 'MicrosoftThreatIntelligence'
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
    properties: {
      kind: 'MicrosoftThreatIntelligence'
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
    name: 'MicrosoftThreatIntelligence'
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
    "properties": {
      "value": {
        "kind": "MicrosoftThreatIntelligence",
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
    },
    "name": {
      "value": "MicrosoftThreatIntelligence"
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
param properties = {
  kind: 'MicrosoftThreatIntelligence'
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
param name = 'MicrosoftThreatIntelligence'
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
    properties: {
      kind: 'MicrosoftThreatIntelligence'
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
    name: 'MicrosoftThreatIntelligence'
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
    "properties": {
      "value": {
        "kind": "MicrosoftThreatIntelligence",
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
    "name": {
      "value": "MicrosoftThreatIntelligence"
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
param properties = {
  kind: 'MicrosoftThreatIntelligence'
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
param name = 'MicrosoftThreatIntelligence'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`properties`](#parameter-properties) | object | The data connector configuration. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`name`](#parameter-name) | string | The name of the data connector. |

### Parameter: `properties`

The data connector configuration.

- Required: Yes
- Type: object
- Discriminator: `kind`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`AmazonWebServicesCloudTrail`](#variant-propertieskind-amazonwebservicescloudtrail) | The type of AmazonWebServicesCloudTrail configuration. |
| [`AmazonWebServicesS3`](#variant-propertieskind-amazonwebservicess3) | The type of AmazonWebServicesS3 configuration. |
| [`APIPolling`](#variant-propertieskind-apipolling) | The type of API Polling configuration. |
| [`AzureActiveDirectory`](#variant-propertieskind-azureactivedirectory) | The type of AzureActiveDirectory configuration. |
| [`AzureAdvancedThreatProtection`](#variant-propertieskind-azureadvancedthreatprotection) | The type of AzureAdvancedThreatProtection configuration. |
| [`AzureSecurityCenter`](#variant-propertieskind-azuresecuritycenter) | The type of AzureSecurityCenter configuration. |
| [`Dynamics365`](#variant-propertieskind-dynamics365) | The type of Dynamics365 configuration. |
| [`GCP`](#variant-propertieskind-gcp) | The type of GCP configuration. |
| [`GenericUI`](#variant-propertieskind-genericui) | The type of Generic UI configuration. |
| [`IOT`](#variant-propertieskind-iot) | The type of IOT configuration. |
| [`MicrosoftCloudAppSecurity`](#variant-propertieskind-microsoftcloudappsecurity) | The type of Microsoft Cloud App Security configuration. |
| [`MicrosoftDefenderAdvancedThreatProtection`](#variant-propertieskind-microsoftdefenderadvancedthreatprotection) | The type of Microsoft Defender Advanced Threat Protection configuration. |
| [`MicrosoftPurviewInformationProtection`](#variant-propertieskind-microsoftpurviewinformationprotection) | The type of Microsoft Purview Information Protection configuration. |
| [`MicrosoftThreatIntelligence`](#variant-propertieskind-microsoftthreatintelligence) | The type of MicrosoftThreatIntelligenceType configuration. |
| [`MicrosoftThreatProtection`](#variant-propertieskind-microsoftthreatprotection) | The type of Microsoft Threat Protection configuration. |
| [`Office365`](#variant-propertieskind-office365) | The type of Office 365 configuration. |
| [`Office365Project`](#variant-propertieskind-office365project) | The type of Office 365 Project configuration. |
| [`OfficeATP`](#variant-propertieskind-officeatp) | The type of Office ATP configuration. |
| [`OfficeIRM`](#variant-propertieskind-officeirm) | The type of Office IRM configuration. |
| [`OfficePowerBI`](#variant-propertieskind-officepowerbi) | The type of Office Power BI configuration. |
| [`PurviewAudit`](#variant-propertieskind-purviewaudit) | The type of Purview Audit configuration. |
| [`RestApiPoller`](#variant-propertieskind-restapipoller) | The type of REST API Poller configuration. |
| [`ThreatIntelligence`](#variant-propertieskind-threatintelligence) | The type of ThreatIntelligenceType configuration. |
| [`ThreatIntelligenceTaxii`](#variant-propertieskind-threatintelligencetaxii) | The type of Threat Intelligence TAXII configuration. |

### Variant: `properties.kind-AmazonWebServicesCloudTrail`
The type of AmazonWebServicesCloudTrail configuration.

To use this variant, set the property `kind` to `AmazonWebServicesCloudTrail`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-amazonwebservicescloudtrailkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-amazonwebservicescloudtrailproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-AmazonWebServicesCloudTrail.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesCloudTrail'
  ]
  ```

### Parameter: `properties.kind-AmazonWebServicesCloudTrail.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`awsRoleArn`](#parameter-propertieskind-amazonwebservicescloudtrailpropertiesawsrolearn) | string | The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account. |
| [`dataTypes`](#parameter-propertieskind-amazonwebservicescloudtrailpropertiesdatatypes) | object | The available data types for the connector. |

### Parameter: `properties.kind-AmazonWebServicesCloudTrail.properties.awsRoleArn`

The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AmazonWebServicesCloudTrail.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-amazonwebservicescloudtrailpropertiesdatatypeslogs) | object | Data type for Amazon Web Services Cloud Trail data connector. |

### Parameter: `properties.kind-AmazonWebServicesCloudTrail.properties.dataTypes.logs`

Data type for Amazon Web Services Cloud Trail data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-amazonwebservicescloudtrailpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.kind-AmazonWebServicesCloudTrail.properties.dataTypes.logs.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Variant: `properties.kind-AmazonWebServicesS3`
The type of AmazonWebServicesS3 configuration.

To use this variant, set the property `kind` to `AmazonWebServicesS3`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-amazonwebservicess3kind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-amazonwebservicess3properties) | object | The properties of the data connector. |

### Parameter: `properties.kind-AmazonWebServicesS3.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AmazonWebServicesS3'
  ]
  ```

### Parameter: `properties.kind-AmazonWebServicesS3.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-amazonwebservicess3propertiesdatatypes) | object | The available data types for the connector. |
| [`destinationTable`](#parameter-propertieskind-amazonwebservicess3propertiesdestinationtable) | string | The logs destination table name in LogAnalytics. |
| [`roleArn`](#parameter-propertieskind-amazonwebservicess3propertiesrolearn) | string | The AWS Role Arn that is used to access the Aws account. |
| [`sqsUrls`](#parameter-propertieskind-amazonwebservicess3propertiessqsurls) | array | The AWS sqs urls for the connector. |

### Parameter: `properties.kind-AmazonWebServicesS3.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-amazonwebservicess3propertiesdatatypeslogs) | object | Data type for Amazon Web Services S3 data connector. |

### Parameter: `properties.kind-AmazonWebServicesS3.properties.dataTypes.logs`

Data type for Amazon Web Services S3 data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-amazonwebservicess3propertiesdatatypeslogsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.kind-AmazonWebServicesS3.properties.dataTypes.logs.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AmazonWebServicesS3.properties.destinationTable`

The logs destination table name in LogAnalytics.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AmazonWebServicesS3.properties.roleArn`

The AWS Role Arn that is used to access the Aws account.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AmazonWebServicesS3.properties.sqsUrls`

The AWS sqs urls for the connector.

- Required: Yes
- Type: array

### Variant: `properties.kind-APIPolling`
The type of API Polling configuration.

To use this variant, set the property `kind` to `APIPolling`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-apipollingkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-apipollingproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-APIPolling.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'APIPolling'
  ]
  ```

### Parameter: `properties.kind-APIPolling.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parseMappings`](#parameter-propertieskind-apipollingpropertiesparsemappings) | array | The parsing rules for the response. |
| [`pollingConfig`](#parameter-propertieskind-apipollingpropertiespollingconfig) | object | The polling configuration for the data connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-propertieskind-apipollingpropertieslookbackperiod) | string | The lookback period for historical data. |

### Parameter: `properties.kind-APIPolling.properties.parseMappings`

The parsing rules for the response.

- Required: Yes
- Type: array

### Parameter: `properties.kind-APIPolling.properties.pollingConfig`

The polling configuration for the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-propertieskind-apipollingpropertiespollingconfigauth) | object | The authentication configuration. |
| [`request`](#parameter-propertieskind-apipollingpropertiespollingconfigrequest) | object | The request configuration. |

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.auth`

The authentication configuration.

- Required: Yes
- Type: object

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoint`](#parameter-propertieskind-apipollingpropertiespollingconfigrequestendpoint) | string | The API endpoint to poll. |
| [`method`](#parameter-propertieskind-apipollingpropertiespollingconfigrequestmethod) | string | The HTTP method to use. |
| [`rateLimitQps`](#parameter-propertieskind-apipollingpropertiespollingconfigrequestratelimitqps) | int | Rate limit in queries per second. |
| [`timeout`](#parameter-propertieskind-apipollingpropertiespollingconfigrequesttimeout) | string | Request timeout duration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`queryParameters`](#parameter-propertieskind-apipollingpropertiespollingconfigrequestqueryparameters) | object | Query parameters to include in the request. |

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.request.endpoint`

The API endpoint to poll.

- Required: Yes
- Type: string

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.request.method`

The HTTP method to use.

- Required: Yes
- Type: string

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.request.rateLimitQps`

Rate limit in queries per second.

- Required: Yes
- Type: int

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.request.timeout`

Request timeout duration.

- Required: Yes
- Type: string

### Parameter: `properties.kind-APIPolling.properties.pollingConfig.request.queryParameters`

Query parameters to include in the request.

- Required: No
- Type: object

### Parameter: `properties.kind-APIPolling.properties.lookbackPeriod`

The lookback period for historical data.

- Required: No
- Type: string

### Variant: `properties.kind-AzureActiveDirectory`
The type of AzureActiveDirectory configuration.

To use this variant, set the property `kind` to `AzureActiveDirectory`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-azureactivedirectorykind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-azureactivedirectoryproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-AzureActiveDirectory.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureActiveDirectory'
  ]
  ```

### Parameter: `properties.kind-AzureActiveDirectory.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-azureactivedirectorypropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertieskind-azureactivedirectorypropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.kind-AzureActiveDirectory.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-azureactivedirectorypropertiesdatatypesalerts) | object | Alerts data type connection. |

### Parameter: `properties.kind-AzureActiveDirectory.properties.dataTypes.alerts`

Alerts data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-azureactivedirectorypropertiesdatatypesalertsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `properties.kind-AzureActiveDirectory.properties.dataTypes.alerts.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AzureActiveDirectory.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.kind-AzureAdvancedThreatProtection`
The type of AzureAdvancedThreatProtection configuration.

To use this variant, set the property `kind` to `AzureAdvancedThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-azureadvancedthreatprotectionkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-azureadvancedthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-AzureAdvancedThreatProtection.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureAdvancedThreatProtection'
  ]
  ```

### Parameter: `properties.kind-AzureAdvancedThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-azureadvancedthreatprotectionpropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertieskind-azureadvancedthreatprotectionpropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.kind-AzureAdvancedThreatProtection.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-azureadvancedthreatprotectionpropertiesdatatypesalerts) | object | Alerts data type connection. |

### Parameter: `properties.kind-AzureAdvancedThreatProtection.properties.dataTypes.alerts`

Alerts data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-azureadvancedthreatprotectionpropertiesdatatypesalertsstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `properties.kind-AzureAdvancedThreatProtection.properties.dataTypes.alerts.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AzureAdvancedThreatProtection.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.kind-AzureSecurityCenter`
The type of AzureSecurityCenter configuration.

To use this variant, set the property `kind` to `AzureSecurityCenter`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-azuresecuritycenterkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-azuresecuritycenterproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-AzureSecurityCenter.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureSecurityCenter'
  ]
  ```

### Parameter: `properties.kind-AzureSecurityCenter.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-azuresecuritycenterpropertiesdatatypes) | object | The available data types for the connector. |
| [`subscriptionId`](#parameter-propertieskind-azuresecuritycenterpropertiessubscriptionid) | string | The subscription id to connect to, and get the data from. |

### Parameter: `properties.kind-AzureSecurityCenter.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-azuresecuritycenterpropertiesdatatypesalerts) | object | Data type for IOT data connector. |

### Parameter: `properties.kind-AzureSecurityCenter.properties.dataTypes.alerts`

Data type for IOT data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-azuresecuritycenterpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.kind-AzureSecurityCenter.properties.dataTypes.alerts.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-AzureSecurityCenter.properties.subscriptionId`

The subscription id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.kind-Dynamics365`
The type of Dynamics365 configuration.

To use this variant, set the property `kind` to `Dynamics365`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-dynamics365kind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-dynamics365properties) | object | The properties of the data connector. |

### Parameter: `properties.kind-Dynamics365.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamics365'
  ]
  ```

### Parameter: `properties.kind-Dynamics365.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-dynamics365propertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertieskind-dynamics365propertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.kind-Dynamics365.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamics365CdsActivities`](#parameter-propertieskind-dynamics365propertiesdatatypesdynamics365cdsactivities) | object | Common Data Service data type connection. |

### Parameter: `properties.kind-Dynamics365.properties.dataTypes.dynamics365CdsActivities`

Common Data Service data type connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-dynamics365propertiesdatatypesdynamics365cdsactivitiesstate) | string | Describe whether this data type connection is enabled or not. |

### Parameter: `properties.kind-Dynamics365.properties.dataTypes.dynamics365CdsActivities.state`

Describe whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-Dynamics365.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.kind-GCP`
The type of GCP configuration.

To use this variant, set the property `kind` to `GCP`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-gcpkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-gcpproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-GCP.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCP'
  ]
  ```

### Parameter: `properties.kind-GCP.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-propertieskind-gcppropertiesauth) | object | The authentication configuration for GCP. |
| [`connectorDefinitionName`](#parameter-propertieskind-gcppropertiesconnectordefinitionname) | string | The name of the connector definition. |
| [`dcrConfig`](#parameter-propertieskind-gcppropertiesdcrconfig) | object | The Data Collection Rule configuration. |
| [`request`](#parameter-propertieskind-gcppropertiesrequest) | object | The request configuration. |

### Parameter: `properties.kind-GCP.properties.auth`

The authentication configuration for GCP.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectNumber`](#parameter-propertieskind-gcppropertiesauthprojectnumber) | string | The GCP project number. |
| [`serviceAccountEmail`](#parameter-propertieskind-gcppropertiesauthserviceaccountemail) | string | The service account email address. |
| [`workloadIdentityProviderId`](#parameter-propertieskind-gcppropertiesauthworkloadidentityproviderid) | string | The workload identity provider ID. |

### Parameter: `properties.kind-GCP.properties.auth.projectNumber`

The GCP project number.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.auth.serviceAccountEmail`

The service account email address.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.auth.workloadIdentityProviderId`

The workload identity provider ID.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.connectorDefinitionName`

The name of the connector definition.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.dcrConfig`

The Data Collection Rule configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpoint`](#parameter-propertieskind-gcppropertiesdcrconfigdatacollectionendpoint) | string | The data collection endpoint. |
| [`dataCollectionRuleImmutableId`](#parameter-propertieskind-gcppropertiesdcrconfigdatacollectionruleimmutableid) | string | The immutable ID of the data collection rule. |
| [`streamName`](#parameter-propertieskind-gcppropertiesdcrconfigstreamname) | string | The name of the data stream. |

### Parameter: `properties.kind-GCP.properties.dcrConfig.dataCollectionEndpoint`

The data collection endpoint.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.dcrConfig.dataCollectionRuleImmutableId`

The immutable ID of the data collection rule.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.dcrConfig.streamName`

The name of the data stream.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectId`](#parameter-propertieskind-gcppropertiesrequestprojectid) | string | The GCP project ID. |
| [`subscriptionNames`](#parameter-propertieskind-gcppropertiesrequestsubscriptionnames) | array | The list of subscription names. |

### Parameter: `properties.kind-GCP.properties.request.projectId`

The GCP project ID.

- Required: Yes
- Type: string

### Parameter: `properties.kind-GCP.properties.request.subscriptionNames`

The list of subscription names.

- Required: Yes
- Type: array

### Variant: `properties.kind-GenericUI`
The type of Generic UI configuration.

To use this variant, set the property `kind` to `GenericUI`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-genericuikind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-genericuiproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-GenericUI.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GenericUI'
  ]
  ```

### Parameter: `properties.kind-GenericUI.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectivityCriteria`](#parameter-propertieskind-genericuipropertiesconnectivitycriteria) | array | The criteria for connector connectivity validation. |
| [`dataTypes`](#parameter-propertieskind-genericuipropertiesdatatypes) | object | The data types for the connector. |

### Parameter: `properties.kind-GenericUI.properties.connectivityCriteria`

The criteria for connector connectivity validation.

- Required: Yes
- Type: array

### Parameter: `properties.kind-GenericUI.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-genericuipropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.kind-GenericUI.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-genericuipropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-GenericUI.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Variant: `properties.kind-IOT`
The type of IOT configuration.

To use this variant, set the property `kind` to `IOT`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-iotkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-iotproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-IOT.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IOT'
  ]
  ```

### Parameter: `properties.kind-IOT.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-iotpropertiesdatatypes) | object | The available data types for the connector. |
| [`subscriptionId`](#parameter-propertieskind-iotpropertiessubscriptionid) | string | The subscription id to connect to, and get the data from. |

### Parameter: `properties.kind-IOT.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-iotpropertiesdatatypesalerts) | object | Data type for IOT data connector. |

### Parameter: `properties.kind-IOT.properties.dataTypes.alerts`

Data type for IOT data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-iotpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.kind-IOT.properties.dataTypes.alerts.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-IOT.properties.subscriptionId`

The subscription id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.kind-MicrosoftCloudAppSecurity`
The type of Microsoft Cloud App Security configuration.

To use this variant, set the property `kind` to `MicrosoftCloudAppSecurity`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-microsoftcloudappsecuritykind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-microsoftcloudappsecurityproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftCloudAppSecurity'
  ]
  ```

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-microsoftcloudappsecuritypropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-microsoftcloudappsecuritypropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-microsoftcloudappsecuritypropertiesdatatypesalerts) | object | The alerts configuration. |
| [`discovery`](#parameter-propertieskind-microsoftcloudappsecuritypropertiesdatatypesdiscovery) | object | The discovery configuration. |

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-microsoftcloudappsecuritypropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties.dataTypes.discovery`

The discovery configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-microsoftcloudappsecuritypropertiesdatatypesdiscoverystate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties.dataTypes.discovery.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftCloudAppSecurity.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-MicrosoftDefenderAdvancedThreatProtection`
The type of Microsoft Defender Advanced Threat Protection configuration.

To use this variant, set the property `kind` to `MicrosoftDefenderAdvancedThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-microsoftdefenderadvancedthreatprotectionkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-microsoftdefenderadvancedthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-MicrosoftDefenderAdvancedThreatProtection.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftDefenderAdvancedThreatProtection'
  ]
  ```

### Parameter: `properties.kind-MicrosoftDefenderAdvancedThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-microsoftdefenderadvancedthreatprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-microsoftdefenderadvancedthreatprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-microsoftdefenderadvancedthreatprotectionpropertiesdatatypesalerts) | object | The alerts configuration. |

### Parameter: `properties.kind-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-microsoftdefenderadvancedthreatprotectionpropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-MicrosoftDefenderAdvancedThreatProtection.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftDefenderAdvancedThreatProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-MicrosoftPurviewInformationProtection`
The type of Microsoft Purview Information Protection configuration.

To use this variant, set the property `kind` to `MicrosoftPurviewInformationProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-microsoftpurviewinformationprotectionkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-microsoftpurviewinformationprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-MicrosoftPurviewInformationProtection.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftPurviewInformationProtection'
  ]
  ```

### Parameter: `properties.kind-MicrosoftPurviewInformationProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-microsoftpurviewinformationprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-microsoftpurviewinformationprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-MicrosoftPurviewInformationProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`incidents`](#parameter-propertieskind-microsoftpurviewinformationprotectionpropertiesdatatypesincidents) | object | The incidents configuration. |

### Parameter: `properties.kind-MicrosoftPurviewInformationProtection.properties.dataTypes.incidents`

The incidents configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-microsoftpurviewinformationprotectionpropertiesdatatypesincidentsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-MicrosoftPurviewInformationProtection.properties.dataTypes.incidents.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftPurviewInformationProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-MicrosoftThreatIntelligence`
The type of MicrosoftThreatIntelligenceType configuration.

To use this variant, set the property `kind` to `MicrosoftThreatIntelligence`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-microsoftthreatintelligencekind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-microsoftthreatintelligenceproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-MicrosoftThreatIntelligence.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftThreatIntelligence'
  ]
  ```

### Parameter: `properties.kind-MicrosoftThreatIntelligence.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-microsoftthreatintelligencepropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertieskind-microsoftthreatintelligencepropertiestenantid) | string | The tenant id to connect to, and get the data from. |

### Parameter: `properties.kind-MicrosoftThreatIntelligence.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`microsoftEmergingThreatFeed`](#parameter-propertieskind-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeed) | object | Data type for Microsoft Threat Intelligence Platforms data connector. |

### Parameter: `properties.kind-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed`

Data type for Microsoft Threat Intelligence Platforms data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-propertieskind-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeedlookbackperiod) | string | The lookback period for the feed to be imported. |
| [`state`](#parameter-propertieskind-microsoftthreatintelligencepropertiesdatatypesmicrosoftemergingthreatfeedstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.kind-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed.lookbackPeriod`

The lookback period for the feed to be imported.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftThreatIntelligence.properties.dataTypes.microsoftEmergingThreatFeed.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftThreatIntelligence.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Variant: `properties.kind-MicrosoftThreatProtection`
The type of Microsoft Threat Protection configuration.

To use this variant, set the property `kind` to `MicrosoftThreatProtection`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-microsoftthreatprotectionkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-microsoftthreatprotectionproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-MicrosoftThreatProtection.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MicrosoftThreatProtection'
  ]
  ```

### Parameter: `properties.kind-MicrosoftThreatProtection.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-microsoftthreatprotectionpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-microsoftthreatprotectionpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-MicrosoftThreatProtection.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`incidents`](#parameter-propertieskind-microsoftthreatprotectionpropertiesdatatypesincidents) | object | The incidents configuration. |

### Parameter: `properties.kind-MicrosoftThreatProtection.properties.dataTypes.incidents`

The incidents configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-microsoftthreatprotectionpropertiesdatatypesincidentsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-MicrosoftThreatProtection.properties.dataTypes.incidents.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-MicrosoftThreatProtection.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-Office365`
The type of Office 365 configuration.

To use this variant, set the property `kind` to `Office365`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-office365kind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-office365properties) | object | The properties of the data connector. |

### Parameter: `properties.kind-Office365.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Office365'
  ]
  ```

### Parameter: `properties.kind-Office365.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-office365propertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-office365propertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-Office365.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exchange`](#parameter-propertieskind-office365propertiesdatatypesexchange) | object | The Exchange configuration. |
| [`sharePoint`](#parameter-propertieskind-office365propertiesdatatypessharepoint) | object | The SharePoint configuration. |
| [`teams`](#parameter-propertieskind-office365propertiesdatatypesteams) | object | The Teams configuration. |

### Parameter: `properties.kind-Office365.properties.dataTypes.exchange`

The Exchange configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-office365propertiesdatatypesexchangestate) | string | Whether the Exchange connection is enabled. |

### Parameter: `properties.kind-Office365.properties.dataTypes.exchange.state`

Whether the Exchange connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-Office365.properties.dataTypes.sharePoint`

The SharePoint configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-office365propertiesdatatypessharepointstate) | string | Whether the SharePoint connection is enabled. |

### Parameter: `properties.kind-Office365.properties.dataTypes.sharePoint.state`

Whether the SharePoint connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-Office365.properties.dataTypes.teams`

The Teams configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-office365propertiesdatatypesteamsstate) | string | Whether the Teams connection is enabled. |

### Parameter: `properties.kind-Office365.properties.dataTypes.teams.state`

Whether the Teams connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-Office365.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-Office365Project`
The type of Office 365 Project configuration.

To use this variant, set the property `kind` to `Office365Project`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-office365projectkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-office365projectproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-Office365Project.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Office365Project'
  ]
  ```

### Parameter: `properties.kind-Office365Project.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-office365projectpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-office365projectpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-Office365Project.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-office365projectpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.kind-Office365Project.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-office365projectpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-Office365Project.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-Office365Project.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-OfficeATP`
The type of Office ATP configuration.

To use this variant, set the property `kind` to `OfficeATP`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-officeatpkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-officeatpproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-OfficeATP.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficeATP'
  ]
  ```

### Parameter: `properties.kind-OfficeATP.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-officeatppropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-officeatppropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-OfficeATP.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alerts`](#parameter-propertieskind-officeatppropertiesdatatypesalerts) | object | The alerts configuration. |

### Parameter: `properties.kind-OfficeATP.properties.dataTypes.alerts`

The alerts configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-officeatppropertiesdatatypesalertsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-OfficeATP.properties.dataTypes.alerts.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-OfficeATP.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-OfficeIRM`
The type of Office IRM configuration.

To use this variant, set the property `kind` to `OfficeIRM`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-officeirmkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-officeirmproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-OfficeIRM.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficeIRM'
  ]
  ```

### Parameter: `properties.kind-OfficeIRM.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-officeirmpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-officeirmpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-OfficeIRM.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-officeirmpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.kind-OfficeIRM.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-officeirmpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-OfficeIRM.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-OfficeIRM.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-OfficePowerBI`
The type of Office Power BI configuration.

To use this variant, set the property `kind` to `OfficePowerBI`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-officepowerbikind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-officepowerbiproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-OfficePowerBI.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OfficePowerBI'
  ]
  ```

### Parameter: `properties.kind-OfficePowerBI.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-officepowerbipropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-officepowerbipropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-OfficePowerBI.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-officepowerbipropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.kind-OfficePowerBI.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-officepowerbipropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-OfficePowerBI.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-OfficePowerBI.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-PurviewAudit`
The type of Purview Audit configuration.

To use this variant, set the property `kind` to `PurviewAudit`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-purviewauditkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-purviewauditproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-PurviewAudit.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PurviewAudit'
  ]
  ```

### Parameter: `properties.kind-PurviewAudit.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-purviewauditpropertiesdatatypes) | object | The data types for the connector. |
| [`tenantId`](#parameter-propertieskind-purviewauditpropertiestenantid) | string | The tenant id to connect to. |

### Parameter: `properties.kind-PurviewAudit.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-propertieskind-purviewauditpropertiesdatatypeslogs) | object | The logs configuration. |

### Parameter: `properties.kind-PurviewAudit.properties.dataTypes.logs`

The logs configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-purviewauditpropertiesdatatypeslogsstate) | string | Whether this data type connection is enabled. |

### Parameter: `properties.kind-PurviewAudit.properties.dataTypes.logs.state`

Whether this data type connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-PurviewAudit.properties.tenantId`

The tenant id to connect to.

- Required: Yes
- Type: string

### Variant: `properties.kind-RestApiPoller`
The type of REST API Poller configuration.

To use this variant, set the property `kind` to `RestApiPoller`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-restapipollerkind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-restapipollerproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-RestApiPoller.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'RestApiPoller'
  ]
  ```

### Parameter: `properties.kind-RestApiPoller.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parseMappings`](#parameter-propertieskind-restapipollerpropertiesparsemappings) | array | The parsing rules for the response. |
| [`pollingConfig`](#parameter-propertieskind-restapipollerpropertiespollingconfig) | object | The polling configuration for the data connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`lookbackPeriod`](#parameter-propertieskind-restapipollerpropertieslookbackperiod) | string | The lookback period for historical data. |

### Parameter: `properties.kind-RestApiPoller.properties.parseMappings`

The parsing rules for the response.

- Required: Yes
- Type: array

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig`

The polling configuration for the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-propertieskind-restapipollerpropertiespollingconfigauth) | object | The authentication configuration. |
| [`request`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequest) | object | The request configuration. |

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.auth`

The authentication configuration.

- Required: Yes
- Type: object

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request`

The request configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoint`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequestendpoint) | string | The API endpoint to poll. |
| [`method`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequestmethod) | string | The HTTP method to use. |
| [`rateLimitQps`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequestratelimitqps) | int | Rate limit in queries per second. |
| [`timeout`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequesttimeout) | string | Request timeout duration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`headers`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequestheaders) | object | Additional headers to include in the request. |
| [`queryParameters`](#parameter-propertieskind-restapipollerpropertiespollingconfigrequestqueryparameters) | object | Query parameters to include in the request. |

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request.endpoint`

The API endpoint to poll.

- Required: Yes
- Type: string

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request.method`

The HTTP method to use.

- Required: Yes
- Type: string

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request.rateLimitQps`

Rate limit in queries per second.

- Required: Yes
- Type: int

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request.timeout`

Request timeout duration.

- Required: Yes
- Type: string

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request.headers`

Additional headers to include in the request.

- Required: No
- Type: object

### Parameter: `properties.kind-RestApiPoller.properties.pollingConfig.request.queryParameters`

Query parameters to include in the request.

- Required: No
- Type: object

### Parameter: `properties.kind-RestApiPoller.properties.lookbackPeriod`

The lookback period for historical data.

- Required: No
- Type: string

### Variant: `properties.kind-ThreatIntelligence`
The type of ThreatIntelligenceType configuration.

To use this variant, set the property `kind` to `ThreatIntelligence`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-threatintelligencekind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-threatintelligenceproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-ThreatIntelligence.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ThreatIntelligence'
  ]
  ```

### Parameter: `properties.kind-ThreatIntelligence.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-threatintelligencepropertiesdatatypes) | object | The available data types for the connector. |
| [`tenantId`](#parameter-propertieskind-threatintelligencepropertiestenantid) | string | The tenant id to connect to, and get the data from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tipLookbackPeriod`](#parameter-propertieskind-threatintelligencepropertiestiplookbackperiod) | string | The lookback period for the feed to be imported. |

### Parameter: `properties.kind-ThreatIntelligence.properties.dataTypes`

The available data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`indicators`](#parameter-propertieskind-threatintelligencepropertiesdatatypesindicators) | object | Data type for indicators connection. |

### Parameter: `properties.kind-ThreatIntelligence.properties.dataTypes.indicators`

Data type for indicators connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-propertieskind-threatintelligencepropertiesdatatypesindicatorsstate) | string | Whether this data type connection is enabled or not. |

### Parameter: `properties.kind-ThreatIntelligence.properties.dataTypes.indicators.state`

Whether this data type connection is enabled or not.

- Required: Yes
- Type: string

### Parameter: `properties.kind-ThreatIntelligence.properties.tenantId`

The tenant id to connect to, and get the data from.

- Required: Yes
- Type: string

### Parameter: `properties.kind-ThreatIntelligence.properties.tipLookbackPeriod`

The lookback period for the feed to be imported.

- Required: No
- Type: string

### Variant: `properties.kind-ThreatIntelligenceTaxii`
The type of Threat Intelligence TAXII configuration.

To use this variant, set the property `kind` to `ThreatIntelligenceTaxii`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-propertieskind-threatintelligencetaxiikind) | string | The type of data connector. |
| [`properties`](#parameter-propertieskind-threatintelligencetaxiiproperties) | object | The properties of the data connector. |

### Parameter: `properties.kind-ThreatIntelligenceTaxii.kind`

The type of data connector.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ThreatIntelligenceTaxii'
  ]
  ```

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties`

The properties of the data connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypes`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypes) | object | The data types for the connector. |

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes`

The data types for the connector.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`taxiiClient`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclient) | object | The TAXII client configuration. |

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient`

The TAXII client configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`collectionId`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclientcollectionid) | string | The collection ID to fetch from. |
| [`state`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclientstate) | string | Whether this connection is enabled. |
| [`taxiiServer`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclienttaxiiserver) | string | The TAXII server URL. |
| [`workspaceId`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclientworkspaceid) | string | The workspace ID for the connector. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`password`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclientpassword) | string | The password for authentication. |
| [`username`](#parameter-propertieskind-threatintelligencetaxiipropertiesdatatypestaxiiclientusername) | string | The username for authentication. |

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.collectionId`

The collection ID to fetch from.

- Required: Yes
- Type: string

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.state`

Whether this connection is enabled.

- Required: Yes
- Type: string

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.taxiiServer`

The TAXII server URL.

- Required: Yes
- Type: string

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.workspaceId`

The workspace ID for the connector.

- Required: Yes
- Type: string

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.password`

The password for authentication.

- Required: No
- Type: string

### Parameter: `properties.kind-ThreatIntelligenceTaxii.properties.dataTypes.taxiiClient.username`

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

### Parameter: `name`

The name of the data connector.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed data connector. |
| `resourceGroupName` | string | The resource group where the Security Insights Data Connector is deployed. |
| `resourceId` | string | The resource ID of the deployed data connector. |
| `resourceType` | string | The resource type of the deployed data connector. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity of the deployed data connector. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

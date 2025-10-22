metadata name = 'Security Insights Data Connectors'
metadata description = 'This module deploys a Security Insights Data Connector.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource ID of the Log Analytics workspace.')
param workspaceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The name of the data connector.')
param name string?

@description('Required. The data connector configuration.')
param properties dataConnectorType

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.securityinsights-dataconnector.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: last(split(workspaceResourceId, '/'))
}

resource dataConnector 'Microsoft.SecurityInsights/dataConnectors@2025-03-01' = {
  scope: workspace
  name: name ?? properties.kind
  kind: properties.kind
  properties: properties.properties
}

@description('The name of the deployed data connector.')
output name string = dataConnector.name

@description('The resource ID of the deployed data connector.')
output resourceId string = dataConnector.id

@description('The resource type of the deployed data connector.')
output resourceType string = '${dataConnector.type}/${properties.?name}'

@description('The principal ID of the system assigned identity of the deployed data connector.')
output systemAssignedPrincipalId string = contains(dataConnector, 'identity') ? dataConnector.identity.principalId : ''

@description('The resource group where the Security Insights Data Connector is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type of a site configuration.')
@discriminator('kind')
type dataConnectorType =
  | amazonWebServicesCloudTrailType
  | amazonWebServicesS3Type
  | apiPollingType
  | azureActiveDirectoryType
  | azureAdvancedThreatProtectionType
  | azureSecurityCenterType
  | dynamics365Type
  | gcpType
  | genericUiType
  | iotType
  | microsoftCloudAppSecurityType
  | microsoftDefenderAdvancedThreatProtectionType
  | microsoftPurviewInformationProtectionType
  | microsoftThreatIntelligenceType
  | microsoftThreatProtectionType
  | office365Type
  | office365ProjectType
  | officeATPType
  | officeIRMType
  | officePowerBIType
  | purviewAuditType
  | restApiPollerType
  | threatIntelligenceType
  | threatIntelligenceTaxiiType

@export()
@description('The type of API Polling configuration.')
type apiPollingType = {
  @description('Required. The type of data connector.')
  kind: 'APIPolling'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The polling configuration for the data connector.')
    pollingConfig: {
      @description('Required. The authentication configuration.')
      auth: object
      @description('Required. The request configuration.')
      request: {
        @description('Required. The API endpoint to poll.')
        endpoint: string
        @description('Required. The HTTP method to use.')
        method: string
        @description('Optional. Query parameters to include in the request.')
        queryParameters: object?
        @description('Required. Rate limit in queries per second.')
        rateLimitQps: int
        @description('Required. Request timeout duration.')
        timeout: string
      }
    }
    @description('Optional. The lookback period for historical data.')
    lookbackPeriod: string?
    @description('Required. The parsing rules for the response.')
    parseMappings: array
  }
}

@export()
@description('The type of Generic UI configuration.')
type genericUiType = {
  @description('Required. The type of data connector.')
  kind: 'GenericUI'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The logs configuration.')
      logs: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The criteria for connector connectivity validation.')
    connectivityCriteria: array
  }
}

@export()
@description('The type of Microsoft Cloud App Security configuration.')
type microsoftCloudAppSecurityType = {
  @description('Required. The type of data connector.')
  kind: 'MicrosoftCloudAppSecurity'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The alerts configuration.')
      alerts: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
      @description('Required. The discovery configuration.')
      discovery: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Microsoft Defender Advanced Threat Protection configuration.')
type microsoftDefenderAdvancedThreatProtectionType = {
  @description('Required. The type of data connector.')
  kind: 'MicrosoftDefenderAdvancedThreatProtection'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The alerts configuration.')
      alerts: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Microsoft Purview Information Protection configuration.')
type microsoftPurviewInformationProtectionType = {
  @description('Required. The type of data connector.')
  kind: 'MicrosoftPurviewInformationProtection'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The incidents configuration.')
      incidents: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Microsoft Threat Protection configuration.')
type microsoftThreatProtectionType = {
  @description('Required. The type of data connector.')
  kind: 'MicrosoftThreatProtection'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The incidents configuration.')
      incidents: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Office 365 configuration.')
type office365Type = {
  @description('Required. The type of data connector.')
  kind: 'Office365'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The Exchange configuration.')
      exchange: {
        @description('Required. Whether the Exchange connection is enabled.')
        state: string
      }
      @description('Required. The SharePoint configuration.')
      sharePoint: {
        @description('Required. Whether the SharePoint connection is enabled.')
        state: string
      }
      @description('Required. The Teams configuration.')
      teams: {
        @description('Required. Whether the Teams connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Office 365 Project configuration.')
type office365ProjectType = {
  @description('Required. The type of data connector.')
  kind: 'Office365Project'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The logs configuration.')
      logs: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Office ATP configuration.')
type officeATPType = {
  @description('Required. The type of data connector.')
  kind: 'OfficeATP'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The alerts configuration.')
      alerts: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Office IRM configuration.')
type officeIRMType = {
  @description('Required. The type of data connector.')
  kind: 'OfficeIRM'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The logs configuration.')
      logs: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Office Power BI configuration.')
type officePowerBIType = {
  @description('Required. The type of data connector.')
  kind: 'OfficePowerBI'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The logs configuration.')
      logs: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of Purview Audit configuration.')
type purviewAuditType = {
  @description('Required. The type of data connector.')
  kind: 'PurviewAudit'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The logs configuration.')
      logs: {
        @description('Required. Whether this data type connection is enabled.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to.')
    tenantId: string
  }
}

@export()
@description('The type of REST API Poller configuration.')
type restApiPollerType = {
  @description('Required. The type of data connector.')
  kind: 'RestApiPoller'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The polling configuration for the data connector.')
    pollingConfig: {
      @description('Required. The authentication configuration.')
      auth: object
      @description('Required. The request configuration.')
      request: {
        @description('Required. The API endpoint to poll.')
        endpoint: string
        @description('Required. The HTTP method to use.')
        method: string
        @description('Optional. Additional headers to include in the request.')
        headers: object?
        @description('Optional. Query parameters to include in the request.')
        queryParameters: object?
        @description('Required. Rate limit in queries per second.')
        rateLimitQps: int
        @description('Required. Request timeout duration.')
        timeout: string
      }
    }
    @description('Optional. The lookback period for historical data.')
    lookbackPeriod: string?
    @description('Required. The parsing rules for the response.')
    parseMappings: array
  }
}

@export()
@description('The type of Threat Intelligence TAXII configuration.')
type threatIntelligenceTaxiiType = {
  @description('Required. The type of data connector.')
  kind: 'ThreatIntelligenceTaxii'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The data types for the connector.')
    dataTypes: {
      @description('Required. The TAXII client configuration.')
      taxiiClient: {
        @description('Required. Whether this connection is enabled.')
        state: string
        @description('Required. The TAXII server URL.')
        taxiiServer: string
        @description('Required. The collection ID to fetch from.')
        collectionId: string
        @description('Optional. The username for authentication.')
        username: string?
        @description('Optional. The password for authentication.')
        password: string?
        @description('Required. The workspace ID for the connector.')
        workspaceId: string
      }
    }
  }
}

@export()
@description('The type of AmazonWebServicesCloudTrail configuration.')
type amazonWebServicesCloudTrailType = {
  @description('Required. The type of data connector.')
  kind: 'AmazonWebServicesCloudTrail'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The AWS Role Arn (with CloudTrailReadOnly policy) that is used to access the AWS account.')
    awsRoleArn: string
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for Amazon Web Services Cloud Trail data connector.')
      logs: {
        @description('Required. Whether this data type connection is enabled or not.')
        state: string
      }
    }
  }
}

@export()
@description('The type of AmazonWebServicesS3 configuration.')
type amazonWebServicesS3Type = {
  @description('Required. The type of data connector.')
  kind: 'AmazonWebServicesS3'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for Amazon Web Services S3 data connector.')
      logs: {
        @description('Required. Whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The logs destination table name in LogAnalytics.')
    destinationTable: string
    @description('Required. The AWS Role Arn that is used to access the Aws account.')
    roleArn: string
    @description('Required. The AWS sqs urls for the connector.')
    sqsUrls: string[]
  }
}

@export()
@description('The type of AzureActiveDirectory configuration.')
type azureActiveDirectoryType = {
  @description('Required. The type of data connector.')
  kind: 'AzureActiveDirectory'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Alerts data type connection.')
      alerts: {
        @description('Required. Describe whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to, and get the data from.')
    tenantId: string
  }
}

@export()
@description('The type of AzureAdvancedThreatProtection configuration.')
type azureAdvancedThreatProtectionType = {
  @description('Required. The type of data connector.')
  kind: 'AzureAdvancedThreatProtection'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Alerts data type connection.')
      alerts: {
        @description('Required. Describe whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to, and get the data from.')
    tenantId: string
  }
}

@export()
@description('The type of AzureSecurityCenter configuration.')
type azureSecurityCenterType = {
  @description('Required. The type of data connector.')
  kind: 'AzureSecurityCenter'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for IOT data connector.')
      alerts: {
        @description('Required. Whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The subscription id to connect to, and get the data from.')
    subscriptionId: string
  }
}

@export()
@description('The type of Dynamics365 configuration.')
type dynamics365Type = {
  @description('Required. The type of data connector.')
  kind: 'Dynamics365'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Common Data Service data type connection.')
      dynamics365CdsActivities: {
        @description('Required. Describe whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to, and get the data from.')
    tenantId: string
  }
}

@export()
@description('The type of GCP configuration.')
type gcpType = {
  @description('Required. The type of data connector.')
  kind: 'GCP'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The authentication configuration for GCP.')
    auth: {
      @description('Required. The GCP project number.')
      projectNumber: string
      @description('Required. The service account email address.')
      serviceAccountEmail: string
      @description('Required. The workload identity provider ID.')
      workloadIdentityProviderId: string
    }
    @description('Required. The name of the connector definition.')
    connectorDefinitionName: string
    @description('Required. The Data Collection Rule configuration.')
    dcrConfig: {
      @description('Required. The data collection endpoint.')
      dataCollectionEndpoint: string
      @description('Required. The immutable ID of the data collection rule.')
      dataCollectionRuleImmutableId: string
      @description('Required. The name of the data stream.')
      streamName: string
    }
    @description('Required. The request configuration.')
    request: {
      @description('Required. The GCP project ID.')
      projectId: string
      @description('Required. The list of subscription names.')
      subscriptionNames: string[]
    }
  }
}

@export()
@description('The type of IOT configuration.')
type iotType = {
  @description('Required. The type of data connector.')
  kind: 'IOT'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for IOT data connector.')
      alerts: {
        @description('Required. Whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The subscription id to connect to, and get the data from.')
    subscriptionId: string
  }
}

@export()
@description('The type of MicrosoftThreatIntelligenceType configuration.')
type microsoftThreatIntelligenceType = {
  @description('Required. The type of data connector.')
  kind: 'MicrosoftThreatIntelligence'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for Microsoft Threat Intelligence Platforms data connector.')
      microsoftEmergingThreatFeed: {
        @description('Required. The lookback period for the feed to be imported.')
        lookbackPeriod: string
        @description('Required. Whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to, and get the data from.')
    tenantId: string
  }
}

@export()
@description('The type of ThreatIntelligenceType configuration.')
type threatIntelligenceType = {
  @description('Required. The type of data connector.')
  kind: 'ThreatIntelligence'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for indicators connection.')
      indicators: {
        @description('Required. Whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to, and get the data from.')
    tenantId: string
    @description('Optional. The lookback period for the feed to be imported.')
    tipLookbackPeriod: string?
  }
}

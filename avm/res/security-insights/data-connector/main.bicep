metadata name = 'Security Insights Data Connectors'
metadata description = 'This module deploys a Security Insights Data Connector.'
metadata owner = 'Azure/module-maintainers'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

@description('Required. The resource ID of the Log Analytics workspace.')
param workspaceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@allowed([
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
])
@description('Required. The type of Data Connector.')
param connectors dataConnectorType[]?

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

resource dataConnector 'Microsoft.SecurityInsights/dataConnectors@2024-10-01-preview' = [
  for (connector, index) in (connectors ?? []): {
    scope: workspace
    name: connector.name
    kind: connector.name
    properties: connector.?properties
  }
]

@description('The name of the Security Insights Data Connector.')
output name string = length(connectors ?? []) > 0 ? dataConnector[0].name : ''

@description('The resource ID of the Security Insights Data Connector.')
output resourceId string = length(connectors ?? []) > 0 ? dataConnector[0].id : ''

@description('The resource group where the Security Insights Data Connector is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type of a site configuration.')
@discriminator('name')
type dataConnectorType = MicrosoftThreatIntelligenceType | ThreatIntelligenceType

@export()
@description('The type of MicrosoftThreatIntelligenceType configuration.')
type MicrosoftThreatIntelligenceType = {
  @description('Required. The type of data connector.')
  name: 'MicrosoftThreatIntelligence'
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
type ThreatIntelligenceType = {
  @description('Required. The type of data connector.')
  name: 'ThreatIntelligence'
  @description('Required. The properties of the data connector.')
  properties: {
    @description('Required. The available data types for the connector.')
    dataTypes: {
      @description('Required. Data type for indicators connection.')
      indicators: {
        @description('Required. Describe whether this data type connection is enabled or not.')
        state: string
      }
    }
    @description('Required. The tenant id to connect to, and get the data from.')
    tenantId: string
    @description('Optional. The lookback period for the feed to be imported.')
    tipLookbackPeriod: string?
  }
}

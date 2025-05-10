metadata name = 'Security Insights Data Connectors'
metadata description = 'This module deploys a Security Insights Data Connector.'
metadata owner = 'Azure/module-maintainers'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

@description('Required. Name of the Security Insights Data Connector.')
param name string

@description('Required. The resource ID of the Log Analytics workspace.')
param workspaceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableTelemetry bool = true

@description('Required. The type of the Data Connector.')
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
param dataConnectorType string

@description('Optional. Properties for the Data Connector based on kind.')
param properties object = {}

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

resource dataConnector 'Microsoft.SecurityInsights/dataConnectors@2024-10-01-preview' = {
  scope: workspace
  name: name
  kind: dataConnectorType
  properties: properties
}

@description('The name of the Security Insights Data Connector.')
output name string = dataConnector.name

@description('The resource ID of the Security Insights Data Connector.')
output resourceId string = dataConnector.id

@description('The resource group where the Security Insights Data Connector is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location

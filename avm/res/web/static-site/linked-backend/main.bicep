metadata name = 'Static Web App Site Linked Backends'
metadata description = 'This module deploys a Custom Function App into a Static Web App Site using the Linked Backends property.'

@description('Required. The resource ID of the backend linked to the static site.')
param backendResourceId string

@description('Optional. The region of the backend linked to the static site.')
param region string = resourceGroup().location

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Name of the backend to link to the static site.')
param name string = uniqueString(backendResourceId)

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-staticsite-linkedbackend.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource staticSite 'Microsoft.Web/staticSites@2025-03-01' existing = {
  name: staticSiteName
}

resource linkedBackend 'Microsoft.Web/staticSites/linkedBackends@2025-03-01' = {
  name: name
  parent: staticSite
  properties: {
    backendResourceId: backendResourceId
    region: region
  }
}

@description('The name of the static site linked backend.')
output name string = linkedBackend.name

@description('The resource ID of the static site linked backend.')
output resourceId string = linkedBackend.id

@description('The resource group the static site linked backend was deployed into.')
output resourceGroupName string = resourceGroup().name

metadata name = 'Service Fabric Cluster Application Types'
metadata description = 'This module deploys a Service Fabric Cluster Application Type.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Service Fabric cluster. Required if the template is used in a standalone deployment.')
param serviceFabricClusterName string

@description('Optional. Application type name.')
param name string = 'defaultApplicationType'

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' existing = {
  name: serviceFabricClusterName
}

resource applicationTypes 'Microsoft.ServiceFabric/clusters/applicationTypes@2021-06-01' = {
  name: name
  parent: serviceFabricCluster
  tags: tags
}

@description('The resource name of the Application type.')
output name string = applicationTypes.name

@description('The resource group of the Application type.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Application type.')
output resourceID string = applicationTypes.id

metadata name = 'API Management Service Backends'
metadata description = 'This module deploys an API Management Service Backend.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Backend Name.')
param name string

@sys.description('Optional. Backend Credentials Contract Properties.')
param credentials object = {}

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. Backend Description.')
param description string = ''

@sys.description('Optional. Backend communication protocol. - http or soap.')
param protocol string = 'http'

@sys.description('Optional. Backend Proxy Contract Properties.')
param proxy object = {}

@sys.description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.')
param resourceId string = ''

@sys.description('Optional. Backend Service Fabric Cluster Properties.')
param serviceFabricCluster object = {}

@sys.description('Optional. Backend Title.')
param title string = ''

@sys.description('Optional. Backend TLS Properties.')
param tls object = {
  validateCertificateChain: false
  validateCertificateName: false
}

@sys.description('Required. Runtime URL of the Backend.')
param url string

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

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource backend 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: name
  parent: service
  properties: {
    title: !empty(title) ? title : null
    description: !empty(description) ? description : null
    resourceId: !empty(resourceId) ? resourceId : null
    properties: {
      serviceFabricCluster: !empty(serviceFabricCluster) ? serviceFabricCluster : null
    }
    credentials: !empty(credentials) ? credentials : null
    proxy: !empty(proxy) ? proxy : null
    tls: !empty(tls) ? tls : null
    url: url
    protocol: protocol
  }
}

@sys.description('The resource ID of the API management service backend.')
output resourceId string = backend.id

@sys.description('The name of the API management service backend.')
output name string = backend.name

@sys.description('The resource group the API management service backend was deployed into.')
output resourceGroupName string = resourceGroup().name

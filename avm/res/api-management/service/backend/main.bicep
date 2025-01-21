metadata name = 'API Management Service Backends'
metadata description = 'This module deploys an API Management Service Backend.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Backend Name.')
param name string

@sys.description('Optional. Backend Credentials Contract Properties.')
param credentials object?

@sys.description('Optional. Backend Description.')
param description string?

@sys.description('Optional. Backend communication protocol. - http or soap.')
param protocol string = 'http'

@sys.description('Optional. Backend Proxy Contract Properties.')
param proxy object?

@sys.description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.')
param resourceId string?

@sys.description('Optional. Backend Service Fabric Cluster Properties.')
param serviceFabricCluster object?

@sys.description('Optional. Backend Title.')
param title string?

@sys.description('Optional. Backend TLS Properties.')
param tls object = {
  validateCertificateChain: false
  validateCertificateName: false
}

@sys.description('Required. Runtime URL of the Backend.')
param url string

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource backend 'Microsoft.ApiManagement/service/backends@2022-08-01' = {
  name: name
  parent: service
  properties: {
    title: title
    description: description
    resourceId: resourceId
    properties: {
      serviceFabricCluster: serviceFabricCluster
    }
    credentials: credentials
    proxy: proxy
    tls: tls
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

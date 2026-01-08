metadata name = 'API Management Workspace Backends'
metadata description = 'This module deploys a Backend in an API Management Workspace.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Required. Backend Name.')
param name string

@sys.description('Optional. Backend Credentials Contract Properties. Not supported for Backend Pools.')
param credentials resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.credentials?

@sys.description('Optional. Backend Description.')
param description string?

@sys.description('Optional. Backend communication protocol. http or soap. Not supported for Backend Pools.')
param protocol string = 'http'

@sys.description('Optional. Backend Proxy Contract Properties. Not supported for Backend Pools.')
param proxy resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.proxy?

@sys.description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools.')
param resourceId string?

@sys.description('Optional. Backend Service Fabric Cluster Properties. Not supported for Backend Pools.')
param serviceFabricCluster resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.properties.serviceFabricCluster?

@sys.description('Optional. Backend Title.')
param title string?

@sys.description('Optional. Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true.')
param tls resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.tls?

@minLength(1)
@maxLength(2000)
@sys.description('Conditional. Runtime URL of the Backend. Required if type is Single and not supported if type is Pool.')
param url string?

@sys.description('Optional. Backend Circuit Breaker Configuration. Not supported for Backend Pools.')
param circuitBreaker resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.circuitBreaker?

@sys.description('Conditional. Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single.')
param pool resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.pool?

@sys.description('Optional. Type of the backend. A backend can be either Single or Pool.')
@allowed(['Single', 'Pool'])
param type string = 'Single'

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName
  }
}

resource backend 'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01' = {
  name: name
  parent: service::workspace
  properties: {
    description: description
    title: title
    type: type
    ...(type == 'Single'
      ? {
          resourceId: resourceId
          credentials: credentials
          proxy: proxy
          circuitBreaker: circuitBreaker
          protocol: protocol
          properties: {
            serviceFabricCluster: serviceFabricCluster
          }
          tls: tls ?? {
            validateCertificateChain: true
            validateCertificateName: true
          }
          url: url
        }
      : {
          pool: pool
        })
  }
}

@sys.description('The resource ID of the workspace backend.')
output resourceId string = backend.id

@sys.description('The name of the workspace backend.')
output name string = backend.name

@sys.description('The resource group the workspace backend was deployed into.')
output resourceGroupName string = resourceGroup().name

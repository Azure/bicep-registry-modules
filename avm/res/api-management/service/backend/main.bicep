metadata name = 'API Management Service Backends'
metadata description = 'This module deploys an API Management Service Backend.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Backend Name.')
param name string

@sys.description('Optional. Backend Credentials Contract Properties. Not supported for Backend Pools.')
param credentials resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.credentials?

@sys.description('Optional. Backend Description.')
param description string?

@sys.description('Optional. Backend communication protocol. http or soap. Not supported for Backend Pools.')
param protocol string = 'http'

@sys.description('Optional. Backend Proxy Contract Properties. Not supported for Backend Pools.')
param proxy resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.proxy?

@sys.description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools.')
param resourceId string?

@sys.description('Optional. Backend Service Fabric Cluster Properties. Not supported for Backend Pools.')
param serviceFabricCluster resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.properties.serviceFabricCluster?

@sys.description('Optional. Backend Title.')
param title string?

@sys.description('Optional. Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true.')
param tls resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.tls?

@minLength(1)
@maxLength(2000)
@sys.description('Conditional. Runtime URL of the Backend. Required if type is Single and not supported if type is Pool.')
param url string?

@sys.description('Optional. Backend Circuit Breaker Configuration. Not supported for Backend Pools.')
param circuitBreaker resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.circuitBreaker?

@sys.description('Conditional. Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single.')
param pool resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.pool?

@sys.description('Optional. Type of the backend. A backend can be either Single or Pool.')
@allowed(['Single', 'Pool'])
param type string = 'Single'

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-backend.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource backend 'Microsoft.ApiManagement/service/backends@2024-05-01' = {
  name: name
  parent: service
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

@sys.description('The resource ID of the API management service backend.')
output resourceId string = backend.id

@sys.description('The name of the API management service backend.')
output name string = backend.name

@sys.description('The resource group the API management service backend was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the API Management service.')
param name string

@description('The location of the API Management service.')
param location string

@description('Name of the API Management publisher.')
param publisherName string

@description('The email address of the API Management publisher.')
param publisherEmail string

@description('Optional. The pricing tier of this API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
  'StandardV2'
  'BasicV2'
])
param sku string

@description('Specifies whether to create a private endpoint for the API Management service.')
param networkIsolation bool

@description('The resource ID of the Log Analytics workspace to use for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string

@description('Resource ID of the virtual network to link the private DNS zones.')
param virtualNetworkResourceId string

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

@description('Optional tags to be applied to the resources.')
param tags object = {}


module apiManagementService 'br/public:avm/res/api-management/service:0.9.1' = {
  name: take('${name}-apim-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    sku: sku
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: networkIsolation ? 'Internal' : 'None'
    managedIdentities: {
      systemAssigned: true
    }
    apis: [
      {
        apiVersionSet: {
          name: 'echo-version-set'
          properties: {
            description: 'An echo API version set'
            displayName: 'Echo version set'
            versioningScheme: 'Segment'
          }
        }
        description: 'An echo API service'
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        protocols: [
          'https'
        ]
        serviceUrl: 'https://echoapi.cloudapp.net/api'
      }
    ]
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'True'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
    }
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceResourceId
      }
    ]
    products: [
      {
        apis: [
          {
            name: 'echo-api'
          }
        ]
        approvalRequired: true
        description: 'This is an echo API'
        displayName: 'Echo API'
        groups: [
          {
            name: 'developers'
          }
        ]
        name: 'Starter'
        subscriptionRequired: true
        terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
      }
    ]
    subscriptions: [
      {
        displayName: 'testArmSubscriptionAllApis'
        name: 'testArmSubscriptionAllApis'
        scope: '/apis'
      }
    ]
  }
}

module apiManagementPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = if (networkIsolation)  {
  name: 'private-dns-apim-deployment'
  params: {
    name: 'privatelink.apim.windows.net'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}


module apimPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.0' = if (networkIsolation) {
  name: take('${name}-apim-private-endpoint-deployment', 64)
  params: {
    name: toLower('pep-${apiManagementService.outputs.name}')
    subnetResourceId: virtualNetworkSubnetResourceId
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: apiManagementPrivateDnsZone.outputs.resourceId
        }
      ]
    }
    privateLinkServiceConnections: [
      {
        name: apiManagementService.outputs.name
        properties: {
          groupIds: [
            'Gateway'
          ]
          privateLinkServiceId: apiManagementService.outputs.resourceId
        }
      }
    ]
  }
}

output resourceId string = apiManagementService.outputs.resourceId
output name string = apiManagementService.outputs.name
output privateEndpointId string = apimPrivateEndpoint.outputs.resourceId
output privateEndpointName string = apimPrivateEndpoint.outputs.name


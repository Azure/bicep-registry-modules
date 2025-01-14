targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The location where the resources will be created.')
param location string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('The naming conventions to use for resources.')
param resourceNames object

@description('Required. Whether to enable deplotment telemetry.')
param enableTelemetry bool

// Container App Environment
@description('The ID of the Container Apps environment to be used for the deployment. (e.g. /subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.App/managedEnvironments/XXX)')
param containerAppsEnvironmentId string

// Private Link Service
@description('The resource ID of the subnet to be used for the private link service. (e.g. /subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.Network/virtualNetworks/XXX/subnets/XXX)')
param privateLinkSubnetId string

@description('The name of the front door endpoint to be created.')
param frontDoorEndpointName string = 'fde-containerapps'

@description('The name of the front door origin group to be created.')
param frontDoorOriginGroupName string = 'containerapps-origin-group'

@description('The name of the front door origin to be created.')
param frontDoorOriginName string = 'containerapps-origin'

@description('The name of the front door origin route to be created.')
param frontDoorOriginRouteName string = 'containerapps-route'

@description('The host name of the front door origin to be created.')
param frontDoorOriginHostName string

// ------------------
// VARIABLES
// ------------------

var containerAppsEnvironmentTokens = split(containerAppsEnvironmentId, '/')
var containerAppsEnvironmentSubscriptionId = containerAppsEnvironmentTokens[2]
var containerAppsEnvironmentResourceGroupName = containerAppsEnvironmentTokens[4]
var containerAppsEnvironmentName = containerAppsEnvironmentTokens[8]

// ------------------
// RESOURCES
// ------------------
resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  scope: resourceGroup(containerAppsEnvironmentSubscriptionId, containerAppsEnvironmentResourceGroupName)
  name: containerAppsEnvironmentName
}

module privateLinkService 'private-link-service.bicep' = {
  name: 'privateLinkServiceFrontDoorDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    tags: tags
    containerAppsDefaultDomainName: containerAppsEnvironment.properties.defaultDomain
    containerAppsEnvironmentSubscriptionId: containerAppsEnvironmentSubscriptionId
    privateLinkServiceName: resourceNames.frontDoorPrivateLinkService
    privateLinkSubnetId: privateLinkSubnetId
  }
}

module frontDoor 'br/public:avm/res/cdn/profile:0.3.0' = {
  name: 'frontDoorDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    // Required parameters
    name: 'dep-test-cdnpmax'
    location: 'Global'
    sku: 'Premium_AzureFrontDoor'
    tags: tags
    enableTelemetry: enableTelemetry
    originResponseTimeoutSeconds: 60
    // Non-required parameters
    endpointProperties: {
      contentTypesToCompress: [
        'application/javascript'
        'application/json'
        'application/x-javascript'
        'application/xml'
        'text/css'
        'text/html'
        'text/javascript'
        'text/plain'
      ]
      geoFilters: []
      isCompressionEnabled: true
      isHttpAllowed: true
      isHttpsAllowed: true
      queryStringCachingBehavior: 'IgnoreQueryString'
    }
    originGroups: (!empty(frontDoorOriginHostName))
      ? [
          {
            name: frontDoorOriginGroupName
            loadBalancingSettings: {
              sampleSize: 4
              successfulSamplesRequired: 3
              additionalLatencyInMilliseconds: 50
            }
            healthProbeSettings: {
              probePath: '/'
              probeRequestType: 'HEAD'
              probeProtocol: 'Https'
              probeIntervalInSeconds: 100
            }
            sessionAffinityState: 'Disabled'
            origins: [
              {
                name: frontDoorOriginName
                hostName: frontDoorOriginHostName
                httpPort: 80
                httpsPort: 443
                originHostHeader: frontDoorOriginHostName
                priority: 1
                weight: 1000
                enabledState: 'Enabled'
                sharedPrivateLinkResource: {
                  privateLink: {
                    id: privateLinkService.outputs.privateLinkServiceId
                  }
                  privateLinkLocation: location
                  requestMessage: 'frontdoor'
                }
                enforceCertificateNameCheck: true
              }
            ]
          }
        ]
      : []
    afdEndpoints: [
      {
        name: frontDoorEndpointName
        originGroup: frontDoorOriginGroupName
        enabledState: 'Enabled'
        routes: [
          {
            name: frontDoorOriginRouteName
            originPath: '/'
            ruleSets: []
            supportedProtocols: [
              'Http'
              'Https'
            ]
            patternsToMatch: [
              '/*'
            ]
            forwardingProtocol: 'HttpsOnly'
            linkToDefaultDomain: 'Enabled'
            httpsRedirect: 'Enabled'
            enabledState: 'Enabled'
          }
        ]
      }
    ]
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The ID of the front door resource.')
output frontDoorResourceId string = frontDoor.outputs.resourceId
@description('The ID of the private link service.')
output privateLinkServiceId string = privateLinkService.outputs.privateLinkServiceId
@description('The ID of the private link endpoint connection to approve.')
output privateLinkEndpointConnectionId string = length(privateLinkService.outputs.privateEndpointConnections) > 0
  ? filter(
      privateLinkService.outputs.privateEndpointConnections,
      (connection) => connection.properties.privateLinkServiceConnectionState.description == 'frontdoor'
    )[0].id
  : ''

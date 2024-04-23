targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.frontdoors-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nfdwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// Diagnostics
// ============
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //
var resourceName = '${namePrefix}${serviceShort}001'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: resourceName
      location: resourceLocation
      backendPools: [
        {
          name: 'backendPool'
          properties: {
            backends: [
              {
                address: 'biceptest.local'
                backendHostHeader: 'backendAddress'
                enabledState: 'Enabled'
                httpPort: 80
                httpsPort: 443
                priority: 1
                privateLinkAlias: ''
                privateLinkApprovalMessage: ''
                privateLinkLocation: ''
                weight: 50
              }
            ]
            HealthProbeSettings: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/HealthProbeSettings/heathProbe'
            }
            LoadBalancingSettings: {
              id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/LoadBalancingSettings/loadBalancer'
            }
          }
        }
      ]
      enforceCertificateNameCheck: 'Disabled'
      frontendEndpoints: [
        {
          name: 'frontEnd'
          properties: {
            hostName: '${resourceName}.${environment().suffixes.azureFrontDoorEndpointSuffix}'
            sessionAffinityEnabledState: 'Disabled'
            sessionAffinityTtlSeconds: 60
          }
        }
      ]
      healthProbeSettings: [
        {
          name: 'heathProbe'
          properties: {
            enabledState: 'Enabled'
            healthProbeMethod: 'HEAD'
            intervalInSeconds: 60
            path: '/healthz'
            protocol: 'Https'
          }
        }
      ]
      loadBalancingSettings: [
        {
          name: 'loadBalancer'
          properties: {
            additionalLatencyMilliseconds: 0
            sampleSize: 50
            successfulSamplesRequired: 1
          }
        }
      ]
      routingRules: [
        {
          name: 'routingRule'
          properties: {
            acceptedProtocols: [
              'Http'
              'Https'
            ]
            enabledState: 'Enabled'
            frontendEndpoints: [
              {
                id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/FrontendEndpoints/frontEnd'
              }
            ]
            patternsToMatch: [
              '/*'
            ]
            routeConfiguration: {
              '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
              backendPool: {
                id: '${resourceGroup.id}/providers/Microsoft.Network/frontDoors/${resourceName}/BackendPools/backendPool'
              }
              forwardingProtocol: 'MatchRequest'
            }
          }
        }
      ]
      sendRecvTimeoutSeconds: 10
      diagnosticSettings: [
        {
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]

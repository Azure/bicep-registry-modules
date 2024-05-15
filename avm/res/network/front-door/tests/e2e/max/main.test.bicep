targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.frontdoors-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nfdmax'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
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
            enabledState: ''
            healthProbeMethod: ''
            intervalInSeconds: 60
            path: '/'
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
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
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
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          logCategoriesAndGroups: [
            {
              category: 'FrontdoorAccessLog'
            }
          ]
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

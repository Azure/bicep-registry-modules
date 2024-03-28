targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.azurefirewalls-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nafwaf'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
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

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      virtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
      applicationRuleCollections: [
        {
          name: 'allow-app-rules'
          properties: {
            action: {
              type: 'Allow'
            }
            priority: 100
            rules: [
              {
                fqdnTags: [
                  'AppServiceEnvironment'
                  'WindowsUpdate'
                ]
                name: 'allow-ase-tags'
                protocols: [
                  {
                    port: 80
                    protocolType: 'Http'
                  }
                  {
                    port: 443
                    protocolType: 'Https'
                  }
                ]
                sourceAddresses: [
                  '*'
                ]
              }
              {
                name: 'allow-ase-management'
                protocols: [
                  {
                    port: 80
                    protocolType: 'Http'
                  }
                  {
                    port: 443
                    protocolType: 'Https'
                  }
                ]
                sourceAddresses: [
                  '*'
                ]
                targetFqdns: [
                  'bing.com'
                ]
              }
            ]
          }
        }
      ]
      publicIPResourceID: nestedDependencies.outputs.publicIPResourceId
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      networkRuleCollections: [
        {
          name: 'allow-network-rules'
          properties: {
            action: {
              type: 'Allow'
            }
            priority: 100
            rules: [
              {
                destinationAddresses: [
                  '*'
                ]
                destinationPorts: [
                  '12000'
                  '123'
                ]
                name: 'allow-ntp'
                protocols: [
                  'Any'
                ]
                sourceAddresses: [
                  '*'
                ]
              }
            ]
          }
        }
      ]
      zones: [
        '1'
        '2'
        '3'
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]

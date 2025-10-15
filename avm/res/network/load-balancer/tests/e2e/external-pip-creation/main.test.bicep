targetScope = 'subscription'

metadata name = 'Using public IP load balancer parameter - public IP addresses'
metadata description = 'This instance deploys the module with the minimum set of required parameters and creates an external public IP for the frontend.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.loadbalancers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nlbpip'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: resourceLocation
  }
}

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      frontendIPConfigurations: [
        {
          name: 'publicIPConfig1'
          pipConfiguration: {
            name: '${namePrefix}${serviceShort}-pip-001'
            skuName: 'Standard'
            skuTier: 'Regional'
            allocationMethod: 'Static'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
        }
        {
          name: 'publicIPConfig2'
          pipConfiguration: {
            name: '${namePrefix}${serviceShort}-pip-002'
            skuName: 'Standard'
            skuTier: 'Regional'
            allocationMethod: 'Static'
            zones: [
              '1'
              '2'
              '3'
            ]
          }
        }
      ]
    }
  }
]

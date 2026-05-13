targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module with the WAF-aligned baseline enabled (Key Vault, VNet integration, Private Endpoints, managed identity, HTTPS-only and TLS 1.2 enforcement).'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.function-app-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wfawaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

// Note: This test exercises Private Endpoints but does not deploy private DNS
// zones. Name resolution from the VNet to the PEs is not validated; the
// deployment validates the AVM module's PE wiring only.
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      functionAppName: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      enableWafAlignment: true
      appServicePlanSkuName: 'EP1'
      appServicePlanSkuCapacity: 2
      functionAppKind: 'functionapp,linux'
      functionWorkerRuntime: 'dotnet-isolated'
      functionAppSubnetResourceId: nestedDependencies.outputs.functionAppSubnetResourceId
      privateEndpointSubnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
        'hidden-title': 'This is visible in the resource name'
      }
      functionAppTags: {
        'azd-service-name': 'api'
      }
    }
  }
]

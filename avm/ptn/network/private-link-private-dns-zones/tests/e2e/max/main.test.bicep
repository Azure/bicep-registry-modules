targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-ptn-pl-pdns-zones-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'plpdnsmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    virtualNetwork1Name: 'dep-${namePrefix}-vnet1-${serviceShort}'
    virtualNetwork2Name: 'dep-${namePrefix}-vnet2-${serviceShort}'
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
      privateLinkPrivateDnsZones: [
        'privatelink.api.azureml.ms'
        'privatelink.notebooks.azure.net'
        'privatelink.{regionCode}.backup.windowsazure.com'
        'privatelink.{regionName}.azmk8s.io'
      ]
      privateLinkPrivateDnsZonesToExclude: [
        'privatelink.api.azureml.ms'
        'privatelink.{regionCode}.backup.windowsazure.com'
      ]
      additionalPrivateLinkPrivateDnsZonesToInclude: [
        'privatelink.3.azurestaticapps.net'
      ]
      virtualNetworkResourceIdsToLinkTo: [
        nestedDependencies.outputs.vnet1ResourceId
      ]
      virtualNetworkLinks: [
        {
          name: 'vnet2-link-custom-name'
          virtualNetworkResourceId: nestedDependencies.outputs.vnet2ResourceId
          resolutionPolicy: 'NxDomainRedirect'
          registrationEnabled: false
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Example'
            Role: 'DeploymentValidation'
          }
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'pdnsZonesLock'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Example'
        Role: 'DeploymentValidation'
      }
    }
  }
]

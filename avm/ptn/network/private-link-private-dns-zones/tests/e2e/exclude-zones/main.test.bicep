targetScope = 'subscription'

metadata name = 'Exclude specific zones from defaults'
metadata description = 'This instance deploys and excludes 3 zones from the default set of zones using the parameter `privateLinkPrivateDnsZonesToExclude`. The default set of zones is defined in the module in the parameter `privateLinkPrivateDnsZones`.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-ptn-pl-pdns-zones-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'plpdnsexcl'

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

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      privateLinkPrivateDnsZonesToExclude: [
        'privatelink.monitor.azure.com'
        'privatelink.{regionCode}.backup.windowsazure.com'
        'privatelink.{regionName}.azmk8s.io'
      ]
    }
  }
]

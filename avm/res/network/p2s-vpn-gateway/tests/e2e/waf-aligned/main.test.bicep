targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.p2svpngateway-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'npvgwaf'

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
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}p2sVpnGw'
      location: resourceLocation
      tags: {
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      p2SConnectionConfigurationsName: 'p2sConnectionConfig1'
      isRoutingPreferenceInternet: false
      enableInternetSecurity: true
      associatedRouteTableName: 'defaultRouteTable'
      vpnClientAddressPoolAddressPrefixes: [
        '10.0.2.0/24'
      ]
      virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
      vpnServerConfigurationResourceId: nestedDependencies.outputs.vpnServerConfigurationResourceId
    }
  }
]

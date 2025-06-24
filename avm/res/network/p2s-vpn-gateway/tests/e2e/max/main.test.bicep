targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.p2svpngateway-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'npvgmax'

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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}p2sVpnGw'
      customDnsServers: [
        '10.50.10.50'
        '10.50.50.50'
      ]
      isRoutingPreferenceInternet: false
      enableInternetSecurity: false
      associatedRouteTableName: 'noneRouteTable'
      inboundRouteMapResourceId: nestedDependencies.outputs.hubRouteMapResourceId
      outboundRouteMapResourceId: nestedDependencies.outputs.hubRouteMapResourceId
      propagatedRouteTableNames: [
        nestedDependencies.outputs.hubRouteTableName
      ]
      propagatedLabelNames: nestedDependencies.outputs.hubRouteTableLabels
      vpnClientAddressPoolAddressPrefixes: [
        '10.0.2.0/24'
        '10.0.3.0/24'
      ]
      virtualHubResourceId: nestedDependencies.outputs.virtualHubResourceId
      vpnGatewayScaleUnit: 5
      vpnServerConfigurationResourceId: nestedDependencies.outputs.vpnServerConfigurationResourceId
      p2SConnectionConfigurationsName: 'p2sConnectionConfig'
    }
  }
]

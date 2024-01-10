targetScope = 'subscription'

metadata name = 'VPN'
metadata description = 'This instance deploys the module with the VPN set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgvpn'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location // Just a value to avoid ongoing capaity challenges
var tempLocation = 'francecentral'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    location: tempLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    localNetworkGatewayName: 'dep-${namePrefix}-lng-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    location: tempLocation
    name: '${namePrefix}${serviceShort}001'
    vpnGatewayGeneration: 'Generation2'
    skuName: 'VpnGw2AZ'
    gatewayType: 'Vpn'
    vNetResourceId: nestedDependencies.outputs.vnetResourceId
    activeActive: true
    domainNameLabel: [
      '${namePrefix}-dm-${serviceShort}'
    ]
    publicIpZones: [
      '1'
      '2'
      '3'
    ]
    vpnType: 'RouteBased'
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: nestedDependencies.outputs.localNetworkGatewayResourceId
    disableIPSecReplayProtection: true
    allowRemoteVnetTraffic: true
    enableBgpRouteTranslationForNat: true
  }
}]


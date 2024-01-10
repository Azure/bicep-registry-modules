targetScope = 'subscription'

metadata name = 'AAD-VPN'
metadata description = 'This instance deploys the module with the AAD set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvngavpn'

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
    skuName: 'VpnGw2AZ'
    gatewayType: 'Vpn'
    vNetResourceId: nestedDependencies.outputs.vnetResourceId
    activeActive: false
    domainNameLabel: [
      '${namePrefix}-dm-${serviceShort}'
    ]
    publicIpZones: [
      '1'
      '2'
      '3'
    ]
    vpnClientAadConfiguration: {
      // The Application ID of the "Azure VPN" Azure AD Enterprise App for Azure Public
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadIssuer: 'https://sts.windows.net/${tenant().tenantId}/'
      aadTenant: '${environment().authentication.loginEndpoint}/${tenant().tenantId}/'
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientProtocols: [
        'OpenVPN'
      ]
    }
    vpnType: 'RouteBased'
  }
}]


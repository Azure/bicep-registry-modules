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
    location: location
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
    location: location
    name: '${namePrefix}${serviceShort}001'
    vpnGatewayGeneration: 'Generation2'
    skuName: 'VpnGw2AZ'
    gatewayType: 'Vpn'
    vNetResourceId: nestedDependencies.outputs.vnetResourceId
    activeActive: true
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
    domainNameLabel: [
      '${namePrefix}-dm-${serviceShort}'
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    publicIpZones: [
      '1'
      '2'
      '3'
    ]
    roleAssignments: [
      {
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        roleDefinitionIdOrName: 'Reader'
        principalType: 'ServicePrincipal'
      }
    ]
    vpnType: 'RouteBased'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: nestedDependencies.outputs.localNetworkGatewayResourceId
    disableIPSecReplayProtection: true
    allowRemoteVnetTraffic: true
    natRules: [
      {
        name: 'nat-rule-1-static-IngressSnat'
        type: 'Static'
        mode: 'IngressSnat'
        internalMappings: [
          {
            addressSpace: '10.100.0.0/24'
            portRange: '100'
          }
        ]
        externalMappings: [
          {
            addressSpace: '192.168.0.0/24'
            portRange: '100'
          }
        ]
      }
      {
        name: 'nat-rule-2-dynamic-EgressSnat'
        type: 'Dynamic'
        mode: 'EgressSnat'
        internalMappings: [
          {
            addressSpace: '172.16.0.0/26'
          }
        ]
        externalMappings: [
          {
            addressSpace: '10.200.0.0/26'
          }
        ]
      }
    ]
    enableBgpRouteTranslationForNat: true
  }
}]


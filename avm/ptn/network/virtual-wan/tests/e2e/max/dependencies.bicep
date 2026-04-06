@description('The name of the Azure Firewall Policy.')
param azureFirewallPolicyName string

@description('The name of the first virtual network.')
param virtualNetwork1Name string

@description('The location of the first virtual network.')
param virtualNetwork1Location string

@description('The name of the second virtual network.')
param virtualNetwork2Name string

@description('The location of the second virtual network.')
param virtualNetwork2Location string

@description('The name of the ExpressRoute circuit.')
param expressRouteCircuitName string

@description('The name of the ExpressRoute port.')
param expressRoutePortName string

@description('The name of the Storage Account for diagnostics.')
param storageAccountName string

@description('The name of the Log Analytics Workspace for diagnostics.')
param logAnalyticsWorkspaceName string

@description('The name of the Event Hub Namespace for diagnostics.')
param eventHubNamespaceName string

@description('The name of the Event Hub within the Event Hub Namespace for diagnostics.')
param eventHubNamespaceEventHubName string

resource azureFirewallPolicy 'Microsoft.Network/firewallPolicies@2024-10-01' = {
  name: azureFirewallPolicyName
  location: resourceGroup().location
  properties: {
    sku: {
      tier: 'Standard'
    }
  }
}

resource vnet1 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: virtualNetwork1Name
  location: virtualNetwork1Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/24'
      ]
    }
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: virtualNetwork2Name
  location: virtualNetwork2Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/24'
      ]
    }
  }
}

module expressRoutePort 'br/public:avm/res/network/express-route-port:0.3.1' = {
  name: expressRoutePortName
  params: {
    name: expressRoutePortName
    location: resourceGroup().location
    bandwidthInGbps: 10
    peeringLocation: 'Equinix-London-LD5'
    encapsulation: 'Dot1Q'
    billingType: 'MeteredData'
    tags: {
      'hidden-title': 'Express Route Port for Circuit'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

module expressRouteCircuit 'br/public:avm/res/network/express-route-circuit:0.8.0' = {
  name: expressRouteCircuitName
  params: {
    name: expressRouteCircuitName
    location: resourceGroup().location
    bandwidthInGbps: 10
    peeringLocation: 'London'
    serviceProviderName: 'Equinix'
    skuTier: 'Premium'
    skuFamily: 'MeteredData'
    globalReachEnabled: true
    expressRoutePortResourceId: expressRoutePort.outputs.resourceId
    authorizationNames: [
      'globalReachAuth1'
    ]
    peerings: [
      {
        name: 'AzurePrivatePeering'
        properties: {
          peeringType: 'AzurePrivatePeering'
          peerASN: 65002
          primaryPeerAddressPrefix: '192.168.100.0/30'
          secondaryPeerAddressPrefix: '192.168.100.4/30'
          vlanId: 100
          state: 'Enabled'
        }
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

// Diagnostic dependencies (Storage Account, Log Analytics Workspace, Event Hub Namespace)
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  name: '${uniqueString(deployment().name)}-diagnosticDependencies'
  params: {
    storageAccountName: storageAccountName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    eventHubNamespaceName: eventHubNamespaceName
    eventHubNamespaceEventHubName: eventHubNamespaceEventHubName
    location: resourceGroup().location
  }
}

@description('The ID of the Azure Firewall Policy.')
output azureFirewallPolicyId string = azureFirewallPolicy.id

@description('The resource ID of the first virtual network.')
output virtualNetwork1Id string = vnet1.id

@description('The name of the first virtual network.')
output virtualNetwork1Name string = vnet1.name

@description('The location of the first virtual network.')
output virtualNetwork1Location string = vnet1.location

@description('The location of the first virtual hub; for testing purposes set as same region of the spoke virtual network.')
output virtualHub1Location string = vnet1.location

@description('The resource ID of the second virtual network.')
output virtualNetwork2Id string = vnet2.id

@description('The name of the second virtual network.')
output virtualNetwork2Name string = vnet2.name

@description('The location of the second virtual network.')
output virtualNetwork2Location string = vnet2.location

@description('The location of the second virtual hub; for testing purposes set as same region of the spoke virtual network.')
output virtualHub2Location string = vnet2.location

@description('The resource ID of the ExpressRoute circuit.')
output expressRouteCircuitId string = expressRouteCircuit.outputs.resourceId

@description('The resource ID of the Log Analytics Workspace.')
output logAnalyticsWorkspaceId string = diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId

@description('The resource ID of the Storage Account used for diagnostics.')
output logAnalyticsStorageAccountId string = diagnosticDependencies.outputs.storageAccountResourceId

@description('The resource ID of the Event Hub Namespace.')
output eventHubNamespaceId string = diagnosticDependencies.outputs.eventHubNamespaceResourceId

@description('The resource ID of the Event Hub Namespace Authorization Rule.')
output eventHubAuthorizationRuleId string = diagnosticDependencies.outputs.eventHubAuthorizationRuleId

@description('The name of the Event Hub.')
output eventHubNamespaceEventHubName string = diagnosticDependencies.outputs.eventHubNamespaceEventHubName

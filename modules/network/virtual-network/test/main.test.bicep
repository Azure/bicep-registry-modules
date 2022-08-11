// ========== //
// Parameters //
// ========== //

// Shared
@description('Optional. The location to deploy resources to')
param location string = resourceGroup().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vnet'

// ========== //
// Test Setup //
// ========== //

// General resources
// =================
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'dep-${serviceShort}-az-msi-x-01'
  location: location
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'dep-${serviceShort}-az-nsg-x-01'
  location: location
}

resource routeTable 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'dep-${serviceShort}-az-rt-x-01'
  location: location
}

resource peeringVNET 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'dep-${serviceShort}-az-vnet-x-01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${serviceShort}-az-subnet-x-001'
        properties: {
          addressPrefix: '10.2.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

// Diagnostics
// ===========
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'adpsxxazsa${serviceShort}01'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  location: location
  properties: {
    allowBlobPublicAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'adp-sxx-law-${serviceShort}-01'
  location: location
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: 'adp-sxx-evhns-${serviceShort}-01'
  location: location

  resource eventHub 'eventhubs@2021-11-01' = {
    name: 'adp-sxx-evh-${serviceShort}-01'
  }

  resource authorizationRule 'authorizationRules@2021-06-01-preview' = {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
}

// ============== //
// Test Execution //
// ============== //

// TEST 1 - MIN
module minvnet '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-minvnet'
  params: {
    name: '${serviceShort}-az-vnet-min-01'
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
  }
}

// TEST 2 - GENERAL
module genvnet '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-genvnet'
  params: {
    name: '${serviceShort}-az-vnet-gen-01'
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.255.0/24'
      }
      {
        name: '${serviceShort}-az-subnet-x-001'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupId: networkSecurityGroup.id
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
        routeTableId: routeTable.id
      }
      {
        name: '${serviceShort}-az-subnet-x-002'
        addressPrefix: '10.0.3.0/24'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
      }
      {
        name: '${serviceShort}-az-subnet-x-003'
        addressPrefix: '10.0.6.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          managedIdentity.properties.principalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: storageAccount.id
    diagnosticWorkspaceId: logAnalyticsWorkspace.id
    diagnosticEventHubAuthorizationRuleId: eventHubNamespace::authorizationRule.id
    diagnosticEventHubName: eventHubNamespace::eventHub.name
  }
}

// TEST 3 - PEERING
module peervnet '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-peervnet'
  params: {
    name: '${serviceShort}-az-vnet-peer-01'
    location: location
    addressPrefixes: [
      '10.0.0.0/24'
    ]

    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.0.0/26'
      }
    ]

    virtualNetworkPeerings: [
      {
        remoteVirtualNetworkId: peeringVNET.id
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        useRemoteGateways: false
        remotePeeringEnabled: true
        remotePeeringName: 'customName'
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
      }
    ]
  }
}

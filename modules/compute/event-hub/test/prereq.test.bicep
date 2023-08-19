param location string
param name string
param prefix string
param blobServiceName string = 'default'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${name}${prefix}01'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  location: location
  properties: {
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: blobServiceName
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${name}${prefix}01'
  parent: blobService
  properties: {}
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-${name}${prefix}-01'
  location: location
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: 'evhns-${name}${prefix}-01'
  location: location
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = {
  name: 'eventHub-${name}${prefix}-01'
  parent: eventHubNamespace
}

resource authorizationRule 'Microsoft.EventHub/namespaces/authorizationRules@2022-01-01-preview' = {
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
  parent: eventHubNamespace
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'vnet-${name}${prefix}-01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${name}-subnet-0'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: '${name}-subnet-1'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.servicebus.windows.net'
  location: 'global'
  properties: {}
}

resource virtualNetworkLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDNSZone
  name: '${name}-${prefix}-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

resource managedIdentity_01 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${name}-${prefix}-01'
  location: location
}

resource managedIdentity_02 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${name}-${prefix}-02'
  location: location
}

output storageAccountId string = storageAccount.id
output containerName string = container.name
output workspaceId string = logAnalyticsWorkspace.id
output eventHubNamespaceId string = eventHubNamespace.id
output eventHubName string = eventHub.name
output authorizationRuleId string = authorizationRule.id
output subnetIds array = [
  virtualNetwork.properties.subnets[0].id
  virtualNetwork.properties.subnets[1].id
]
output privateDNSZoneId string = privateDNSZone.id
output identityPrincipalIds array = [
  managedIdentity_01.properties.principalId
  managedIdentity_02.properties.principalId
]

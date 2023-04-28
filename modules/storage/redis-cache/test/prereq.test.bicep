param location string
param name string
param prefix string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${prefix}${name}01'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  location: location
  properties: {
    allowBlobPublicAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${prefix}-law-${name}-01'
  location: location
  properties: {
    retentionInDays: 30
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: 'ev${prefix}-evhns-${name}-01'
  location: location
  properties: {
    zoneRedundant: false
    disableLocalAuth: false
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  name: 'ev${prefix}-evh-${name}-01'
  parent: eventHubNamespace
  properties: {
   partitionCount: 4
  }
  
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
  name: '${prefix}-${name}-vnet'
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
  name: 'privatelink.azurecr.io'
  location: 'global'
  properties: {}
}

resource virtualNetworkLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDNSZone
  name: '${prefix}-${name}-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

output storageAccountId string = storageAccount.id
output workspaceId string = logAnalyticsWorkspace.id
output eventHubNamespaceId string = eventHubNamespace.id
output eventHubName string = eventHub.name
output authorizationRuleId string = authorizationRule.id
output subnetIds array = [
  virtualNetwork.properties.subnets[0].id
  virtualNetwork.properties.subnets[1].id
]
output privateDNSZoneId string = privateDNSZone.id

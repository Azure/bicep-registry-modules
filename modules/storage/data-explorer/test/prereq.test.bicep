param location string
param uniqueName string

param eventHubs array = [
  'eventHub1'
  'eventHub2'
]

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'managedIdentity-${uniqueName}-01'
  location: location
}

var eventhubName = 'test-${uniqueString(resourceGroup().id, deployment().name, location)}'

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: eventhubName
  location: location
  sku: {
    name: 'Standard'
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = [for eventHub in eventHubs: {
  name: eventHub
  parent: eventHubNamespace
}]

module comosdb 'br/public:storage/cosmos-db:3.0.1' = {
  name: 'mycosmosdb'
  params: {
    location: location
    name: 'test01-${uniqueName}'
    backendApi: 'sql'
    sqlDatabases: [
      {
        name: 'testdb1'
        containers: [
          {
            name: 'container1'
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/id' ]
              kind: 'Hash'
              version: 1
            }
          }
        ]
      }
    ]
    roleAssignments: [
      {
        roleDefinitionId: '5bd9cd88-fe45-4216-938b-f97437e15450'
        principalId: identity.properties.principalId
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'virtualNetwork-${uniqueName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${uniqueName}-subnet-0'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: '${uniqueName}-subnet-1'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.eastus.kusto.windows.net'
  location: 'global'
  properties: {}
}

resource virtualNetworkLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDNSZone
  name: 'virtualNetworkLinks-${uniqueName}-vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

output vnetId string = virtualNetwork.id
output subnetIds array = [
  virtualNetwork.properties.subnets[0].id
  virtualNetwork.properties.subnets[1].id
]
output privateDNSZoneId string = privateDNSZone.id

output eventHubResourceId string = eventHub[0].id
output eventHubNamespaceId string = eventHubNamespace.id

output eventHubName string = 'test04na${uniqueName}'
output databaseName string = 'test01-${uniqueName}'
output cosmosDBId string = comosdb.outputs.id
output cosmosDBAccountName string = comosdb.outputs.name
output consumerGroupName string = '$Default'

output identityId string = identity.id
output principalId string = identity.properties.principalId

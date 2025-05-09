@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Event Hub Namespace to create.')
param eventHubNamespaceName string

@description('Required. The name of the Event Hub to create.')
param eventHubName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

var addressPrefix = '10.0.0.0/16'

var privateDNSZoneNames = [
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.servicebus.windows.net'
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${location}-${managedIdentity.id}-EventHubDataReceiver-RoleAssignment')
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'a638d3c7-ab3a-418d-83e6-5f17a39d4fde'
    ) // EventHubDataReceiver
    principalType: 'ServicePrincipal'
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 1
  }
  properties: {
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    kafkaEnabled: true
    zoneRedundant: true
  }

  resource eventHub 'eventhubs@2022-10-01-preview' = {
    name: eventHubName
    properties: {
      messageRetentionInDays: 1
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@batchSize(1)
resource privateDNSZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [
  for privateDNSZone in privateDNSZoneNames: {
    name: privateDNSZone
    location: 'global'
  }
]

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Eventhub Namespace.')
output eventHubNamespaceResourceId string = eventHubNamespace.id

@description('The name of the created Eventhub.')
output eventHubName string = eventHubNamespace::eventHub.name

@description('The resource ID of the created Eventhub.')
output eventHubResourceId string = eventHubNamespace::eventHub.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Private DNS Zone for Purview Account.')
output purviewAccountPrivateDNSResourceId string = privateDNSZones[0].id

@description('The resource ID of the created Private DNS Zone for Purview Portal.')
output purviewPortalPrivateDNSResourceId string = privateDNSZones[1].id

@description('The resource ID of the created Private DNS Zone for Storage Account Blob.')
output storageBlobPrivateDNSResourceId string = privateDNSZones[2].id

@description('The resource ID of the created Private DNS Zone for Storage Account Queue.')
output storageQueuePrivateDNSResourceId string = privateDNSZones[3].id

@description('The resource ID of the created Private DNS Zone for Event Hub Namespace.')
output eventHubPrivateDNSResourceId string = privateDNSZones[4].id

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Event Hub Namespace to create.')
param eventHubNamespaceName string

@description('Required. The name of the Event Hub to create.')
param eventHubName string

@description('Required. Service Bus name')
param serviceBusName string

@description('Required. Event Grid Domain name.')
param eventGridDomainName string

var addressPrefix = '10.0.0.0/16'

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
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.digitaltwins.azure.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: eventHubNamespaceName
  location: location
  properties: {
    zoneRedundant: false
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
  }

  resource eventHub 'eventhubs@2022-10-01-preview' = {
    name: eventHubName
  }
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusName
  location: location
  properties: {
    zoneRedundant: false
  }

  resource topic 'topics@2022-10-01-preview' = {
    name: 'topic'
  }
}

resource eventGridDomain 'Microsoft.EventGrid/domains@2022-06-15' = {
  name: eventGridDomainName
  location: location
  properties: {
    disableLocalAuth: false
  }

  resource topic 'topics@2022-06-15' = {
    name: 'topic'
  }
}

resource eventHubNamespaceRbacAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, 'evhrbacAssignment')
  scope: eventHubNamespace
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2b629674-e913-4c01-ae53-ef4638d8f975') //Azure Event Hubs Data Sender
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource serviceBusRbacAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, 'sbrbacAssignment')
  scope: serviceBus
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39') //Azure Service Bus Data Sender
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalResourceId string = managedIdentity.properties.principalId

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The name of the Event Hub Namespace.')
output eventhubNamespaceName string = eventHubNamespace.name

@description('The resource ID of the created Event Hub Namespace.')
output eventHubResourceId string = eventHubNamespace::eventHub.id

@description('The name of the Event Hub.')
output eventhubName string = eventHubNamespace::eventHub.name

@description('The name of the Service Bus Namespace.')
output serviceBusName string = serviceBus.name

@description('The name of the Service Bus Topic.')
output serviceBusTopicName string = serviceBus::topic.name

@description('The Event Grid endpoint uri.')
output eventGridEndpoint string = eventGridDomain.properties.endpoint

@description('The resource ID of the created Event Grid Topic.')
output eventGridTopicResourceId string = eventGridDomain::topic.id

@description('The resource ID of the created Event Grid Domain.')
output eventGridDomainResourceId string = eventGridDomain.id

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

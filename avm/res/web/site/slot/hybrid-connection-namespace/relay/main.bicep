metadata name = 'Web/Function Apps Slot Hybrid Connection Relay'
metadata description = 'This module deploys a Site Slot Hybrid Connection Namespace Relay.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource ID of the relay namespace hybrid connection.')
param hybridConnectionResourceId string

@description('Conditional. The name of the site slot. Required if the template is used in a standalone deployment.')
param slotName string

@description('Conditional. The name of the parent web site. Required if the template is used in a standalone deployment.')
param appName string

@description('Optional. Name of the authorization rule send key to use.')
param sendKeyName string = 'defaultSender'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' existing = {
  name: split(hybridConnectionResourceId, '/')[8]
  scope: resourceGroup(split(hybridConnectionResourceId, '/')[2], split(hybridConnectionResourceId, '/')[4])

  resource hybridConnection 'hybridConnections@2021-11-01' existing = {
    name: split(hybridConnectionResourceId, '/')[10]

    resource authorizationRule 'authorizationRules@2021-11-01' existing = {
      name: sendKeyName
    }
  }
}

resource hybridConnectionRelay 'Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays@2022-09-01' = {
  name: '${appName}/${slotName}/${namespace.name}/${namespace::hybridConnection.name}'
  properties: {
    serviceBusNamespace: namespace.name
    serviceBusSuffix: split(substring(namespace.properties.serviceBusEndpoint, indexOf(namespace.properties.serviceBusEndpoint, '.servicebus')), ':')[0]
    relayName: namespace::hybridConnection.name
    relayArmUri: namespace::hybridConnection.id
    hostname: split(json(namespace::hybridConnection.properties.userMetadata)[0].value, ':')[0]
    port: int(split(json(namespace::hybridConnection.properties.userMetadata)[0].value, ':')[1])
    sendKeyName: namespace::hybridConnection::authorizationRule.name
    sendKeyValue: namespace::hybridConnection::authorizationRule.listKeys().primaryKey
  }
}

@description('The name of the hybrid connection relay..')
output name string = hybridConnectionRelay.name

@description('The resource ID of the hybrid connection relay.')
output resourceId string = hybridConnectionRelay.id

@description('The name of the resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

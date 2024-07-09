metadata name = 'Event Hub Namespace Disaster Recovery Configs'
metadata description = 'This module deploys an Event Hub Namespace Disaster Recovery Config.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent event hub namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Required. The name of the disaster recovery config.')
param name string

@description('Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing.')
param partnerNamespaceId string = ''

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: namespaceName
}

resource disasterRecoveryConfig 'Microsoft.EventHub/namespaces/disasterRecoveryConfigs@2024-01-01' = {
  name: name
  parent: namespace
  properties: {
    partnerNamespace: partnerNamespaceId
  }
}

@description('The name of the disaster recovery config.')
output name string = disasterRecoveryConfig.name

@description('The resource ID of the disaster recovery config.')
output resourceId string = disasterRecoveryConfig.id

@description('The name of the resource group the disaster recovery config was created in.')
output resourceGroupName string = resourceGroup().name

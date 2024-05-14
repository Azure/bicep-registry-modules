metadata name = 'Recovery Services Vault Replication Fabrics'
metadata description = '''This module deploys a Replication Fabric for Azure to Azure disaster recovery scenario of Azure Site Recovery.

> Note: this module currently support only the `instanceType: 'Azure'` scenario.'''
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Required. The recovery location the fabric represents.')
param location string = resourceGroup().location

@description('Optional. The name of the fabric.')
param name string = location

@description('Optional. Replication containers to create.')
param replicationContainers array = []

resource replicationFabric 'Microsoft.RecoveryServices/vaults/replicationFabrics@2022-10-01' = {
  name: '${recoveryVaultName}/${name}'
  properties: {
    customDetails: {
      instanceType: 'Azure'
      location: location
    }
  }
}

module fabric_replicationContainers 'replication-protection-container/main.bicep' = [
  for (container, index) in replicationContainers: {
    name: '${deployment().name}-RCont-${index}'
    params: {
      name: container.name
      recoveryVaultName: recoveryVaultName
      replicationFabricName: name
      replicationContainerMappings: contains(container, 'replicationContainerMappings')
        ? container.replicationContainerMappings
        : []
    }
    dependsOn: [
      replicationFabric
    ]
  }
]

@description('The name of the replication fabric.')
output name string = replicationFabric.name

@description('The resource ID of the replication fabric.')
output resourceId string = replicationFabric.id

@description('The name of the resource group the replication fabric was created in.')
output resourceGroupName string = resourceGroup().name

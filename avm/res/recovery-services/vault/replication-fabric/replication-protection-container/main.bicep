metadata name = 'Recovery Services Vault Replication Fabric Replication Protection Containers'
metadata description = '''This module deploys a Recovery Services Vault Replication Protection Container.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.'''
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Conditional. The name of the parent Replication Fabric. Required if the template is used in a standalone deployment.')
param replicationFabricName string

@description('Required. The name of the replication container.')
param name string

@description('Optional. Replication containers mappings to create.')
param mappings mappingType[]?

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2024-10-01' existing = {
  name: recoveryVaultName

  resource replicationFabric 'replicationFabrics@2022-10-01' existing = {
    name: replicationFabricName
  }
}

resource replicationContainer 'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers@2022-10-01' = {
  name: name
  parent: recoveryServicesVault::replicationFabric
  properties: {
    providerSpecificInput: [
      {
        instanceType: 'A2A'
      }
    ]
  }
}

module fabric_container_containerMappings 'replication-protection-container-mapping/main.bicep' = [
  for (mapping, index) in (mappings ?? []): {
    name: '${deployment().name}-Map-${index}'
    params: {
      name: mapping.?name
      policyResourceId: mapping.?policyResourceId
      policyName: mapping.?policyName
      recoveryVaultName: recoveryVaultName
      replicationFabricName: replicationFabricName
      sourceProtectionContainerName: replicationContainer.name
      targetProtectionContainerResourceId: mapping.?targetProtectionContainerResourceId
      targetContainerFabricName: mapping.?targetContainerFabricName
      targetContainerName: mapping.?targetContainerName
    }
  }
]

@description('The name of the replication container.')
output name string = replicationContainer.name

@description('The resource ID of the replication container.')
output resourceId string = replicationContainer.id

@description('The name of the resource group the replication container was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for protection container mappings.')
type mappingType = {
  @description('Optional. Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored.')
  targetProtectionContainerResourceId: string?

  @description('Optional. Name of the fabric containing the target container. If targetProtectionContainerResourceId is specified, this parameter will be ignored.')
  targetContainerFabricName: string?

  @description('Optional. Name of the target container. Must be specified if targetProtectionContainerResourceId is not. If targetProtectionContainerResourceId is specified, this parameter will be ignored.')
  targetContainerName: string?

  @description('Optional. Resource ID of the replication policy. If defined, policyName will be ignored.')
  policyResourceId: string?

  @description('Optional. Name of the replication policy. Will be ignored if policyResourceId is also specified.')
  policyName: string?

  @description('Optional. The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`.')
  name: string?
}

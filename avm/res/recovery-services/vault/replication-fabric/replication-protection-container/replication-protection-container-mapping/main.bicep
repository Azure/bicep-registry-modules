metadata name = 'Recovery Services Vault Replication Fabric Replication Protection Container Replication Protection Container Mappings'
metadata description = '''This module deploys a Recovery Services Vault (RSV) Replication Protection Container Mapping.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.'''
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Conditional. The name of the parent Replication Fabric. Required if the template is used in a standalone deployment.')
param replicationFabricName string

@description('Conditional. The name of the parent source Replication container. Required if the template is used in a standalone deployment.')
param sourceProtectionContainerName string

@description('Optional. Resource ID of the target Replication container. Must be specified if targetContainerName is not. If specified, targetContainerFabricName and targetContainerName will be ignored.')
param targetProtectionContainerId string = ''

@description('Optional. Name of the fabric containing the target container. If targetProtectionContainerId is specified, this parameter will be ignored.')
param targetContainerFabricName string = replicationFabricName

@description('Optional. Name of the target container. Must be specified if targetProtectionContainerId is not. If targetProtectionContainerId is specified, this parameter will be ignored.')
param targetContainerName string = ''

@description('Optional. Resource ID of the replication policy. If defined, policyName will be ignored.')
param policyId string = ''

@description('Optional. Name of the replication policy. Will be ignored if policyId is also specified.')
param policyName string = ''

@description('Optional. The name of the replication container mapping. If not provided, it will be automatically generated as `<source_container_name>-<target_container_name>`.')
param name string = ''

var policyResourceId = policyId != ''
  ? policyId
  : subscriptionResourceId('Microsoft.RecoveryServices/vaults/replicationPolicies', recoveryVaultName, policyName)
var targetProtectionContainerResourceId = targetProtectionContainerId != ''
  ? targetProtectionContainerId
  : subscriptionResourceId(
      'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers',
      recoveryVaultName,
      targetContainerFabricName,
      targetContainerName
    )
var mappingName = !empty(name)
  ? name
  : '${sourceProtectionContainerName}-${split(targetProtectionContainerResourceId, '/')[10]}'

resource replicationContainer 'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings@2022-10-01' = {
  name: '${recoveryVaultName}/${replicationFabricName}/${sourceProtectionContainerName}/${mappingName}'
  properties: {
    targetProtectionContainerId: targetProtectionContainerResourceId
    policyId: policyResourceId
    providerSpecificInput: {
      instanceType: 'A2A'
    }
  }
}

@description('The name of the replication container.')
output name string = replicationContainer.name

@description('The resource ID of the replication container.')
output resourceId string = replicationContainer.id

@description('The name of the resource group the replication container was created in.')
output resourceGroupName string = resourceGroup().name

metadata name = 'Recovery Services Vault Replication Policies'
metadata description = '''This module deploys a Recovery Services Vault Replication Policy for Disaster Recovery scenario.

> **Note**: this version of the module only supports the `instanceType: 'A2A'` scenario.'''
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Required. The name of the replication policy.')
param name string

@description('Optional. The app consistent snapshot frequency (in minutes).')
param appConsistentFrequencyInMinutes int = 60

@description('Optional. The crash consistent snapshot frequency (in minutes).')
param crashConsistentFrequencyInMinutes int = 5

@description('Optional. A value indicating whether multi-VM sync has to be enabled.')
@allowed([
  'Enable'
  'Disable'
])
param multiVmSyncStatus string = 'Enable'

@description('Optional. The duration in minutes until which the recovery points need to be stored.')
param recoveryPointHistory int = 1440

resource replicationPolicy 'Microsoft.RecoveryServices/vaults/replicationPolicies@2023-06-01' = {
  name: '${recoveryVaultName}/${name}'
  properties: {
    providerSpecificInput: {
      instanceType: 'A2A'
      appConsistentFrequencyInMinutes: appConsistentFrequencyInMinutes
      crashConsistentFrequencyInMinutes: crashConsistentFrequencyInMinutes
      multiVmSyncStatus: multiVmSyncStatus
      recoveryPointHistory: recoveryPointHistory
    }
  }
}
@description('The name of the replication policy.')
output name string = replicationPolicy.name

@description('The resource ID of the replication policy.')
output resourceId string = replicationPolicy.id

@description('The name of the resource group the replication policy was created in.')
output resourceGroupName string = resourceGroup().name

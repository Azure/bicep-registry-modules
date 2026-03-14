metadata name = 'Storage Account Object Replication Policy'
metadata description = 'This module deploys a Storage Account Object Replication Policy for a provided storage account.'

@description('Required. Name of the policy.')
param name string

@maxLength(24)
@description('Required. The name of the Storage Account on which to create the policy.')
param storageAccountName string

@description('Required. Resource ID of the source storage account for replication.')
param sourceStorageAccountResourceId string

@description('Required. Resource ID of the destination storage account for replication.')
param destinationAccountResourceId string

@description('Optional. Whether metrics are enabled for the object replication policy.')
param enableMetrics bool?

@description('Required. Rules for the object replication policy.')
param rules objectReplicationPolicyRuleType[]

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
}

resource objectReplicationPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2025-01-01' = {
  parent: storageAccount
  name: name
  properties: {
    destinationAccount: destinationAccountResourceId
    metrics: {
      enabled: enableMetrics ?? false
    }
    rules: [
      for rule in rules: {
        ruleId: rule.?ruleId
        sourceContainer: rule.containerName
        destinationContainer: rule.?destinationContainerName ?? rule.containerName
        filters: rule.?filters != null
          ? {
              prefixMatch: rule.?filters.?prefixMatch
              minCreationTime: rule.?filters.?minCreationTime
            }
          : null
      }
    ]
    sourceAccount: sourceStorageAccountResourceId
  }
}

@description('Resource group name of the provisioned resources.')
output resourceGroupName string = resourceGroup().name

@description('Resource ID of the created Object Replication Policy.')
output objectReplicationPolicyId string = objectReplicationPolicy.id

@description('Policy ID of the created Object Replication Policy.')
output policyId string = objectReplicationPolicy.properties.policyId

@description('Rules created Object Replication Policy.')
output rules resourceOutput<'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2025-01-01'>.properties.rules = objectReplicationPolicy.properties.rules

@export()
@description('The type of an object replication policy rule.')
type objectReplicationPolicyRuleType = {
  @description('Optional. The ID of the rule. Auto-generated on destination account. Required for source account.')
  ruleId: string?

  @description('Required. The name of the source container.')
  containerName: string

  @description('Optional. The name of the destination container. If not provided, the same name as the source container will be used.')
  destinationContainerName: string?

  @description('Optional. The filters for the object replication policy rule.')
  filters: {
    @description('Optional. The prefix to match for the replication policy rule.')
    prefixMatch: string[]?

    @description('Optional. The minimum creation time to match for the replication policy rule.')
    minCreationTime: string?
  }?
}

param storageAccountName string
param policy objectReplicationPolicyType

type objectReplicationPolicyType = {
  id: string
  type: ('source' | 'destination')
  @description('The ID of the source storage account.')
  destinationStorageAccountId: string
  sourceStorageAccountId: string
  rules: objectReplicationRuelType[]
}

type objectReplicationRuelType = {
  @description('''
  The ID of the rule. It should be obtaineed from the object relication policy rules of the destination storage account.
  Required if the policyType is "source".
  ''')
  ruleId: string?
  @description('Destination container name.')
  destinationContainer: string
  @description('Source container name.')
  sourceContainer: string
  filters: object?
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource storageAccount_objectReplicationPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2022-09-01' = {
  name: policy.type == 'source' ? policy.id : 'default'
  parent: storageAccount
  properties: {
    sourceAccount: policy.sourceStorageAccountId
    destinationAccount: policy.destinationStorageAccountId
    rules: [for rule in policy.?rules ?? []: {
      ruleId: policy.type == 'source' ? rule.ruleId : null
      sourceContainer: rule.sourceContainer
      destinationContainer: rule.destinationContainer
      filters: rule.?filters
    }]
  }
}

output policyId string = storageAccount_objectReplicationPolicy.properties.policyId
output ruleIds string[] = map(storageAccount_objectReplicationPolicy.properties.rules, rule => rule.ruleId)
metadata name = 'Storage Account Object Replication Policy'
metadata description = 'This module deploys a Storage Account Object Replication Policy for both the source account and destination account.'

@description('Optional. Name of the policy.')
param name string?

@maxLength(24)
@description('Required. The name of the parent Storage Account.')
param storageAccountName string

@description('Required. Resource ID of the destination storage account for replication.')
param destinationAccountResourceId string

@description('Optional. Whether metrics are enabled for the object replication policy.')
param enableMetrics bool?

import { objectReplicationPolicyRuleType } from 'policy/main.bicep'
@description('Required. Rules for the object replication policy.')
param rules objectReplicationPolicyRuleType[]

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
}

var destAccountResourceIdParts = split(destinationAccountResourceId, '/')
var destAccountName = !empty(destAccountResourceIdParts)
  ? last(destAccountResourceIdParts)!
  : destinationAccountResourceId
var destAccountSubscription = length(destAccountResourceIdParts) > 2
  ? destAccountResourceIdParts[2]
  : subscription().subscriptionId
var destAccountResourceGroupName = length(destAccountResourceIdParts) > 4
  ? destAccountResourceIdParts[4]
  : resourceGroup().name

// deploy policy to destination account first
module destinationPolicy 'policy/main.bicep' = {
  name: take('${deployment().name}-ObjRep-Policy-dest-${destAccountName}', 64)
  scope: resourceGroup(destAccountSubscription, destAccountResourceGroupName)
  params: {
    name: name ?? 'default'
    storageAccountName: destAccountName
    sourceStorageAccountResourceId: storageAccount.id
    destinationAccountResourceId: destinationAccountResourceId
    enableMetrics: enableMetrics
    rules: rules
  }
}

// deploy policy to source account second
// set the name as the policy ID from the destination account
// and set the rule IDs from the destination account policy
module sourcePolicy 'policy/main.bicep' = {
  name: take('${deployment().name}-ObjRep-Policy-source-${storageAccount.name}', 64)
  params: {
    name: destinationPolicy.outputs.policyId
    storageAccountName: storageAccount.name
    sourceStorageAccountResourceId: storageAccount.id
    destinationAccountResourceId: destinationAccountResourceId
    enableMetrics: enableMetrics
    rules: [
      for (rule, i) in rules: union(rule, {
        ruleId: destinationPolicy.outputs.rules[i].ruleId
      })
    ]
  }
}

@description('Resource group name of the provisioned resources.')
output resourceGroupName string = resourceGroup().name

@description('Resource ID of the created Object Replication Policy in the source account.')
output objectReplicationPolicyId string = sourcePolicy.outputs.objectReplicationPolicyId

@description('Policy ID of the created Object Replication Policy in the source account.')
output policyId string = sourcePolicy.outputs.policyId

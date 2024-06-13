targetScope = 'managementGroup'

@description('The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.')
param subscriptionManagementGroupId string

@description('The ID of the Subscription to move to the target Management Group')
param subscriptionId string

resource exisitngManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  scope: tenant()
  name: subscriptionManagementGroupId
}

resource managementGroupSubscriptionAssociation 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  parent: exisitngManagementGroup
  name: subscriptionId
}

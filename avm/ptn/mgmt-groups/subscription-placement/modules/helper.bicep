targetScope = 'tenant'

@description('The ID of the management group.')
param managementGroupId string
@description('The list of subscription IDs.')
param subscriptionIds string[]

resource customSubscriptionPlacement 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for (subscription, i) in subscriptionIds: {
    name: '${managementGroupId}/${subscription}'
  }
]

@description('Output of the Management Group and Subscription Resource ID placements.')
output subscriptionPlacements array = [
  for (subscription, i) in subscriptionIds: {
    name: '${managementGroupId}/${subscription}'
  }
]

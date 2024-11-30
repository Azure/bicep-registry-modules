targetScope = 'tenant'

@description('The ID of the management group.')
param managementGroupId string
@description('The list of subscription IDs.')
param subscriptionIds array

resource customsubscriptionPlacement 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [for (subscription,i) in subscriptionIds: {
  name: '${managementGroupId}/${subscription}'
}]

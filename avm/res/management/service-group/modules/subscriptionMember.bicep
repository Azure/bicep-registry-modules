targetScope = 'subscription'

@description('Required. The resource ID of the service group to which the subscription will be associated to.')
param serviceGroupResourceId resourceInput<'Microsoft.Relationships/serviceGroupMember@2023-09-01-preview'>.properties.targetId

resource serviceGroup_subscriptionMember 'Microsoft.Relationships/serviceGroupMember@2023-09-01-preview' = {
  name: uniqueString(subscription().subscriptionId, serviceGroupResourceId)
  properties: {
    targetId: serviceGroupResourceId
  }
  scope: subscription()
}

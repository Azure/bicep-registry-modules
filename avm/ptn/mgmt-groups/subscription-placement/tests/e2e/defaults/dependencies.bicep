targetScope = 'tenant'

@description('Required. The root management group resource ID where the child management group will be placed.')
@secure()
param rootManagementGroupResourceId string = ''


@description('Required. The scope of the subscription billing.')
@secure()
param subscriptionBillingScope string = ''

resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'test-mgmt-group'
  properties: {
    displayName: 'Test Management Group'
    details:{
      parent:{
        id: rootManagementGroupResourceId
      }
    }
  }
}

module subVending 'br/public:avm/ptn/lz/sub-vending:0.2.4' = {
  name: 'subVendingDeployment'
  scope: managementGroup
  params: {
    subscriptionAliasEnabled: true
    subscriptionAliasName: 'TestSubscription'
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionDisplayName: 'TestSubscription'
    subscriptionWorkload: 'DevTest'
  }
}


@description('Output of the Management Group Resource ID.')
output managementGroupId string = managementGroup.id

@description('Output of the Subscription Vending Resource ID.')
output subVendingResourceId string = subVending.outputs.subscriptionId

@description('Output of the Subscription Vending Subscription ID.')
output subVendingSubscriptionId string = subVending.outputs.subscriptionId

